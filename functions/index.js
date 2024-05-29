/* eslint linebreak-style: ["error", "windows"]*/
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const dotenv = require("dotenv");
dotenv.config();

// Initialize Firestore
admin.initializeApp();
const db = admin.firestore();

exports.webhook = functions.https.onRequest(async (req, res) => {
  console.log(req.body);
  try {
    const event = req.body;
    if (event.key === "charge.create" || event.key === "charge.complete") {
      const charge = event.data;
      const chargeId = charge.id;
      const status = charge.status;
      const amount = charge.amount;
      const currency = charge.currency;
      const paidAt = charge.paid_at;
      const userId = charge.metadata.userId;
      const cartItems = JSON.parse(charge.metadata.cartItems);
      const merchantLocation = JSON.parse(charge.metadata.merchantLocation);
      const deliveryLocation = JSON.parse(charge.metadata.deliveryLocation);

      await db.collection("charges").doc(chargeId).set({
        status: status,
        amount: amount,
        currency: currency,
        paidAt: paidAt,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true});

      if (status === "successful") {
        const orderData = {
          chargeId: chargeId,
          amount: amount,
          currency: currency,
          paidAt: paidAt,
          status: "waiting to process", // Initial order status
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          userId: userId, // Add userId to order
          items: cartItems, // Add cart items to order
          merchantLocation: merchantLocation, // Add merchant location to order
          deliveryLocation: deliveryLocation, // Add delivery location to order
          deliveryPartner: null, // Initial delivery partner details
        };

        const orderRef = await db.collection("orders").add(orderData);
        console.log("Order created with ID:", orderRef.id);
      }

      res.status(200).send("Webhook processed successfully");
    } else {
      res.status(400).send("Event type not handled");
    }
  } catch (error) {
    console.error("Error processing webhook:", error);
    res.status(500).send("Internal Server Error");
  }
});
