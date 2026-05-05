# 🚴 VeloRide — Bike Rental and Ride-Sharing Platform
### SE1020 OOP Project | Group G2

---

## 📋 Project Overview
A full-stack web application for bike rental management built with:
- **Backend:** Java 17, Spring Boot 3.2, JSP Servlets
- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap Icons
- **Data Storage:** File-based (txt files — no database needed)
- **IDE:** IntelliJ IDEA

---

## ✅ OOP Concepts Implemented

| Concept | Where Used |
|---|---|
| **Encapsulation** | `User`, `Station` — private fields + getters/setters |
| **Inheritance** | `AdminUser extends User`, `ElectricBike extends Bike`, `StandardBike extends Bike` |
| **Polymorphism** | `calculateFare()` overridden in ElectricBike/StandardBike; `displayForUser()` vs `displayForAdmin()` in Feedback |
| **Abstraction** | Abstract `Bike` class with abstract methods; admin-only methods in `AdminService` |

---

## 📦 Components & CRUD Coverage

| Component | Create | Read | Update | Delete |
|---|---|---|---|---|
| User Management | Register | Search/View | Edit Profile | Delete Account |
| Bike Fleet | Add Bike (Admin) | Search + Sort (QuickSort) | Edit Bike | Remove Bike |
| Ride & Rental | Request Ride | Queue Dashboard | Complete Ride | Cancel/Delete |
| Admin Management | Register Admin | View All | Edit Permissions | Delete Admin |
| Station Management | Add Station | Search/View | Edit Details | Remove Station |
| Feedback & Reviews | Submit Review | View All | Edit Review | Delete/Hide |

---

## 🚀 How to Run in IntelliJ IDEA

### Prerequisites
- Java 17+ (JDK)
- Maven 3.8+
- IntelliJ IDEA (Community or Ultimate)

### Steps

1. **Open Project:**
   - File → Open → select the `BikeRentalPlatform` folder
   - IntelliJ will detect the `pom.xml` and import Maven dependencies automatically

2. **Wait for Maven sync:**
   - Let IntelliJ download all dependencies (check bottom progress bar)

3. **Run the Application:**
   - Open `src/main/java/com/bikerental/BikeRentalApplication.java`
   - Click the green ▶️ Run button next to `main()`
   - OR: Right-click → Run 'BikeRentalApplication'

4. **Access the App:**
   - Open browser: **http://localhost:8080**

### ⚠️ Important: Working Directory
The app writes data files to a `data/` folder.
Make sure IntelliJ's run configuration working directory is set to the **project root**.
- Run → Edit Configurations → Working Directory: `$MODULE_WORKING_DIR$`

---

## 🔑 Demo Login Credentials

| Role | Username | Password |
|---|---|---|
| **Admin** | `admin` | `admin123` |
| **Rider** | `john_doe` | `password123` |
| **Rider** | `jane_smith` | `password123` |

---

## 📁 Data Files (auto-created in `data/`)

| File | Contents |
|---|---|
| `users.txt` | Registered rider accounts |
| `admins.txt` | Admin accounts |
| `bikes.txt` | Bike fleet |
| `stations.txt` | Docking stations |
| `rides.txt` | All ride records |
| `feedback.txt` | Reviews and ratings |

---

## 🗂️ Project Structure

```
BikeRentalPlatform/
├── pom.xml
├── data/                          ← Auto-created data storage
├── src/main/
│   ├── java/com/bikerental/
│   │   ├── BikeRentalApplication.java
│   │   ├── model/
│   │   │   ├── User.java          (Encapsulation)
│   │   │   ├── AdminUser.java     (Inheritance)
│   │   │   ├── Bike.java          (Abstraction)
│   │   │   ├── ElectricBike.java  (Inheritance + Polymorphism)
│   │   │   ├── StandardBike.java  (Inheritance + Polymorphism)
│   │   │   ├── Ride.java
│   │   │   ├── Station.java       (Encapsulation)
│   │   │   └── Feedback.java      (Polymorphism)
│   │   ├── service/
│   │   │   ├── FileHandler.java   ← All file I/O
│   │   │   ├── UserService.java
│   │   │   ├── AdminService.java
│   │   │   ├── BikeService.java
│   │   │   ├── RideService.java   ← Queue data structure
│   │   │   ├── StationService.java
│   │   │   ├── FeedbackService.java
│   │   │   └── DataSeedService.java
│   │   ├── controller/
│   │   │   ├── HomeController.java
│   │   │   ├── UserController.java
│   │   │   ├── BikeController.java
│   │   │   ├── RideController.java
│   │   │   ├── AdminController.java
│   │   │   ├── StationController.java
│   │   │   └── FeedbackController.java
│   │   └── util/
│   │       └── QuickSort.java     ← QuickSort algorithm
│   ├── resources/
│   │   └── application.properties
│   └── webapp/
│       ├── WEB-INF/views/        ← All JSP pages
│       └── static/
│           ├── css/style.css
│           └── js/main.js
```

---

## 📊 Data Structures Used
- **Queue (LinkedList):** `RideService.rentalQueue` — processes rental requests in FIFO order
- **QuickSort:** `QuickSort.java` — sorts bikes by availability and price

---
