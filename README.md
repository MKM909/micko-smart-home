# Micko Smart Home Dashboard 🏠✨

A sleek, modern, and highly interactive Smart Home Management UI built with **Flutter**. This project demonstrates advanced UI/UX techniques including glassmorphism, custom physics-based animations, and a responsive grid layout.

![Smart Home Demo](https://via.placeholder.com/800x400?text=Micko+Smart+Home+Dashboard+Demo)

## ✨ Features

* **Interactive Light Control:** A unique "light rope" pull mechanism to toggle room lighting with integrated haptic feedback.
* **Glassmorphic UI:** Translucent UI elements with subtle background blurs and gradients for a premium look.
* **Device Management:**
    * **Living Room:** Control for Smart Lights, Air Purifiers, TVs, and Power Cords.
    * **Kitchen:** Management for LG InstaView, Coffee Machines, Dishwashers, and Smart Ovens (complete with temperature/timer displays).
* **Energy Insights:** A visual dashboard card displaying monthly energy consumption estimates ($1.5k/month).
* **Dynamic State Handling:** Real-time UI updates when devices are toggled on or off.

## 🛠️ Technical Highlights

The project leverages several Flutter-specific concepts to achieve its high-end feel:

* **Custom Animations:** As seen in `hanging_light_rope.dart`, the pull interaction uses `AnimationController` and `Tween` for smooth, elastic movement.
* **Haptic Feedback:** Uses `HapticFeedback.heavyImpact()` to provide physical satisfaction when "pulling" the light cord.
* **State Management:** Dynamic switching between "Living Room," "Kitchen," and "Dining" tabs with coordinated device states.
* **Responsive Design:** Uses `MediaQuery` to scale icons, fonts, and layouts across different device sizes.

## 📂 Project Structure

| File | Description |
| :--- | :--- |
| `hanging_light_rope.dart` | The custom widget for the pull-to-toggle light animation. |
| `device_card.dart` | Reusable glassmorphic tile for smart devices. |
| `home_page.dart` | The main dashboard shell including user greeting and energy card. |

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/MKM909/micko-smart-home.git](https://github.com/MKM909/micko-smart-home.git)
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## 🎨 UI Reference

The interface features a **"Good Morning, Micah"** personalized greeting and a high-contrast dark mode aesthetic, prioritizing scannability and ease of use.

---

**Developed with ❤️ by Micah**
