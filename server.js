const express = require("express");
const Stripe = require("stripe");
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
const app = express();
const MODELS = ["G1","G2 Pro","G2 Max","G3","G3 Pro","G4","G5","C1 Pro","M5","S1 Pro","T3","V1"];
app.use(express.json());
app.use(express.static(__dirname, { index: "index.html", dotfiles: "ignore" }));
app.post("/checkout", async (req, res) => {
  const model = req.body.model;
  if (!MODELS.includes(model)) return res.status(400).json({ error: "Unknown model" });
  const origin = process.env.SITE_URL || `http://localhost:${process.env.PORT || 3000}`;
  const session = await stripe.checkout.sessions.create({
    mode: "payment",
    line_items: [{ quantity: 1, price_data: { currency: "eur", unit_amount: 4950, product_data: { name: `Kukirin ${model}` } } }],
    shipping_address_collection: { allowed_countries: ["DE","FR","NL","BE","ES","IT","AT"] },
    success_url: `${origin}/?paid=1`,
    cancel_url: origin,
  });
  res.json({ url: session.url });
});
app.listen(process.env.PORT || 3000);
