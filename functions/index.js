/* eslint linebreak-style: ["error", "windows"]*/
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const dotenv = require("dotenv");
dotenv.config();

admin.initializeApp();
const db = admin.firestore();

exports.webhook = functions.https.onRequest(async (req, res) => {
  const event = req.body;
  console.log("Received event:", JSON.stringify(event));

  const chargeId = event.data && event.data.id;

  if (!chargeId || typeof chargeId !== "string" || chargeId.trim() === "") {
    console.error("Invalid chargeId:", chargeId);
    return res.status(400).send("Invalid chargeId.");
  }

  const metadata = event.data.metadata || {};
  const orderId = metadata.order_id;
  const userId = metadata.user_id;
  const status = event.data.status || metadata.status;

  if (event.key === "charge.create") {
    try {
      await db.collection("charges").doc(chargeId).set({
        ...event.data,
        userId,
        status,
      }, {merge: true});

      // Update the order status
      if (orderId) {
        await db.collection("orders").doc(orderId).update({
          status: "payment_processing",
        }, {merge: true});
      }

      console.log(`Charge created with ID: ${chargeId}`);
      res.status(200).send("Successfully responded.");
    } catch (error) {
      console.error("Error creating charge:", error);
      res.status(500).send("Server error response.");
    }
  } else if (event.key === "charge.complete") {
    try {
      await db.collection("charges").doc(chargeId).set({
        status: event.data.status,
      }, {merge: true});

      // Update the order status
      if (orderId) {
        await db.collection("orders").doc(orderId).update({
          status: event.data.status === "successful" ? "completed" : "failed",
        });
      }

      console.log(`Charge completed with ID: ${chargeId}`);
      res.status(200).send("Successfully responded.");
    } catch (error) {
      console.error("Error completing charge:", error);
      res.status(500).send("Server error response.");
    }
  } else {
    console.log("Unhandled event key:", event.key);
    res.status(400).send("Unhandled event key.");
  }
});
