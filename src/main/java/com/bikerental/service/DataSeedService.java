package com.bikerental.service;

import com.bikerental.service.StationService;
import com.bikerental.service.BikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Seeds sample data on first run so the app is demo-ready out of the box.
 */
@Component
public class DataSeedService implements CommandLineRunner {

    @Autowired private AdminService  adminService;
    @Autowired private UserService   userService;
    @Autowired private StationService stationService;
    @Autowired private BikeService   bikeService;
    @Autowired private FileHandler   fileHandler;
    @Autowired private PaymentService paymentService;

    @Override
    public void run(String... args) {
        // 1. Seed default admin
        adminService.seedDefaultAdmin();

        // 2. Seed stations
        stationService.seedSampleStations();

        // 3. Seed sample bikes if none exist
        if (fileHandler.countRecords("bikes.txt") == 0) {
            String s1 = "STA-";   // will be replaced after stations are created
            java.util.List<com.bikerental.model.Station> stations = stationService.getAllStations();
            if (!stations.isEmpty()) {
                String st1 = stations.get(0).getStationId();
                String st2 = stations.size() > 1 ? stations.get(1).getStationId() : st1;
                String st3 = stations.size() > 2 ? stations.get(2).getStationId() : st1;

                bikeService.addElectricBike("Shimano E-500",  st1, 3.50, 85, 60.0, "TYPE_C");
                bikeService.addElectricBike("Trek Allant+ 7", st1, 4.00, 92, 80.0, "TYPE_C");
                bikeService.addElectricBike("Giant Explore E", st2, 3.75, 70, 55.0, "TYPE_A");
                bikeService.addStandardBike("Trek FX 3",      st2, 1.50, 21, "MEDIUM", false);
                bikeService.addStandardBike("Giant Escape 3", st3, 1.25, 24, "LARGE", true);
                bikeService.addStandardBike("Cannondale Quick", st3, 1.75, 7, "SMALL", false);
                bikeService.addMotoBike("Honda CB125F",  st1, 5.00, 125, "PETROL", false, true, "SPORT");
                bikeService.addMotoBike("Yamaha NMAX",   st2, 6.50, 155, "PETROL", true,  true, "SCOOTER");
                bikeService.addMotoBike("Vespa Primavera",st3, 7.00, 125, "PETROL", false, true, "SCOOTER");
            }
        }

        // 4. Seed a sample regular user
        if (fileHandler.countRecords("users.txt") == 0) {
            userService.registerUser("john_doe", "john@example.com",
                    "password123", "0771234567", "VISA");
            userService.registerUser("jane_smith", "jane@example.com",
                    "password123", "0779876543", "MASTERCARD");
        }

        // 4b. Sync station bike counts (recalculate from actual bike data)
        stationService.recalculateAllStations();

        // 5. Seed sample payments
        if (fileHandler.countRecords("payments.txt") == 0) {
            paymentService.createPayment("RDE-DEMO0001", "USR-DEMO0001", "john_doe",  3.50, "VISA");
            paymentService.createPayment("RDE-DEMO0002", "USR-DEMO0001", "john_doe",  7.20, "VISA");
            paymentService.createPayment("RDE-DEMO0003", "USR-DEMO0002", "jane_smith",2.50, "MASTERCARD");
            paymentService.createManualPayment("RDE-DEMO0004","USR-DEMO0002","jane_smith",
                    5.00,"CASH","ADM-DEFAULT1","admin","Paid at station");
        }

        System.out.println("╔══════════════════════════════════════════════╗");
        System.out.println("║   Bike Rental Platform — Started on :8080   ║");
        System.out.println("║   Admin login: admin / admin123             ║");
        System.out.println("║   User  login: john_doe / password123       ║");
        System.out.println("╚══════════════════════════════════════════════╝");
    }
}
