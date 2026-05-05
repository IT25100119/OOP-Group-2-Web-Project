package com.bikerental.controller;

import com.bikerental.model.MotoBike;
import com.bikerental.model.StandardBike;
import com.bikerental.model.ElectricBike;
import com.bikerental.model.Bike;
import com.bikerental.model.AdminUser;
import com.bikerental.service.BikeService;
import com.bikerental.service.StationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * BikeController handles all CRUD operations for Bike Fleet Management.
 * Admin-only for Create/Update/Delete. All users can Read/Search.
 */
@Controller
@RequestMapping("/bikes")
public class BikeController {

    @Autowired private BikeService    bikeService;
    @Autowired private StationService stationService;

    // ─── READ: Public bike list ───────────────────────────────────────────────────

    @GetMapping
    public String listBikes(@RequestParam(required = false) String search,
                            @RequestParam(required = false) String sort,
                            Model model, HttpSession session) {
        if (search != null && !search.isBlank()) {
            model.addAttribute("bikes", bikeService.searchBikes(search));
            model.addAttribute("search", search);
        } else if ("price".equals(sort)) {
            var bikes = bikeService.getAllBikes();
            com.bikerental.util.QuickSort.sortByPrice(bikes);
            model.addAttribute("bikes", bikes);
        } else {
            model.addAttribute("bikes", bikeService.getAllBikesSortedByAvailability());
        }
        model.addAttribute("stations", stationService.getAllStations());
        model.addAttribute("sessionUser", session.getAttribute("loggedUser"));
        model.addAttribute("sessionAdmin", session.getAttribute("loggedAdmin"));
        return "bikes/list";
    }

    // ─── ADMIN: Add Bike Form ────────────────────────────────────────────────────

    @GetMapping("/add")
    public String addBikePage(HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        model.addAttribute("stations", stationService.getAllStations());
        return "bikes/add";
    }

    @PostMapping("/add/electric")
    public String addElectricBike(@RequestParam String model2,
                                  @RequestParam String stationId,
                                  @RequestParam double price,
                                  @RequestParam int battery,
                                  @RequestParam double range,
                                  @RequestParam String charger,
                                  HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        String newId = bikeService.addElectricBike(model2, stationId, price, battery, range, charger);
        model.addAttribute("success", "Electric bike added successfully.");
        model.addAttribute("newBikeId", newId);
        model.addAttribute("newBikeModel", model2);
        model.addAttribute("stations", stationService.getAllStations());
        return "bikes/add";
    }

    @PostMapping("/add/standard")
    public String addStandardBike(@RequestParam String model2,
                                  @RequestParam String stationId,
                                  @RequestParam double price,
                                  @RequestParam int gears,
                                  @RequestParam String frameSize,
                                  @RequestParam(defaultValue = "false") boolean hasBasket,
                                  HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        String newId = bikeService.addStandardBike(model2, stationId, price, gears, frameSize, hasBasket);
        model.addAttribute("success", "Standard bike added successfully.");
        model.addAttribute("newBikeId", newId);
        model.addAttribute("newBikeModel", model2);
        model.addAttribute("stations", stationService.getAllStations());
        return "bikes/add";
    }

    @PostMapping("/add/moto")
    public String addMotoBike(@RequestParam String model2,
                               @RequestParam String stationId,
                               @RequestParam double price,
                               @RequestParam int engineCC,
                               @RequestParam String fuelType,
                               @RequestParam(defaultValue = "false") boolean licenseRequired,
                               @RequestParam(defaultValue = "true")  boolean helmetProvided,
                               @RequestParam(defaultValue = "SCOOTER") String motoClass,
                               HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        String newId = bikeService.addMotoBike(model2, stationId, price, engineCC, fuelType,
                licenseRequired, helmetProvided, motoClass);
        model.addAttribute("success", "Motorbike added successfully.");
        model.addAttribute("newBikeId", newId);
        model.addAttribute("newBikeModel", model2);
        model.addAttribute("stations", stationService.getAllStations());
        return "bikes/add";
    }

    // ─── ADMIN: Edit Bike ────────────────────────────────────────────────────────

    @GetMapping("/edit/{bikeId}")
    public String editBikePage(@PathVariable String bikeId, HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        com.bikerental.model.Bike bike = bikeService.findById(bikeId);
        if (bike == null) return "redirect:/bikes";
        model.addAttribute("bike", bike);
        model.addAttribute("stations", stationService.getAllStations());
        // Pass typed sub-class so JSP can access type-specific getters
        if (bike instanceof com.bikerental.model.ElectricBike)
            model.addAttribute("eBike", (com.bikerental.model.ElectricBike) bike);
        else if (bike instanceof com.bikerental.model.StandardBike)
            model.addAttribute("sBike", (com.bikerental.model.StandardBike) bike);
        else if (bike instanceof com.bikerental.model.MotoBike)
            model.addAttribute("mBike", (com.bikerental.model.MotoBike) bike);
        return "bikes/edit";
    }

    /** Electric bike edit submit */
    @PostMapping("/edit/electric")
    public String updateElectricBike(@RequestParam String bikeId,
                                      @RequestParam String bikeModel,
                                      @RequestParam String status,
                                      @RequestParam String stationId,
                                      @RequestParam double price,
                                      @RequestParam int batteryLevel,
                                      @RequestParam double rangeKm,
                                      @RequestParam String chargerType,
                                      HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        boolean ok = bikeService.updateElectricBike(bikeId, bikeModel, status, stationId,
                price, batteryLevel, rangeKm, chargerType);
        if (ok) { model.addAttribute("success", "Electric bike updated successfully."); }
        else    { model.addAttribute("error",   "Failed to update bike."); }
        return "redirect:/bikes/edit/" + bikeId + (ok ? "?success=1" : "?error=1");
    }

    /** Standard bike edit submit */
    @PostMapping("/edit/standard")
    public String updateStandardBike(@RequestParam String bikeId,
                                      @RequestParam String bikeModel,
                                      @RequestParam String status,
                                      @RequestParam String stationId,
                                      @RequestParam double price,
                                      @RequestParam int gearCount,
                                      @RequestParam String frameSize,
                                      @RequestParam(defaultValue = "false") boolean hasBasket,
                                      HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        boolean ok = bikeService.updateStandardBike(bikeId, bikeModel, status, stationId,
                price, gearCount, frameSize, hasBasket);
        return "redirect:/bikes/edit/" + bikeId + (ok ? "?success=1" : "?error=1");
    }

    /** Moto bike edit submit */
    @PostMapping("/edit/moto")
    public String updateMotoBike(@RequestParam String bikeId,
                                  @RequestParam String bikeModel,
                                  @RequestParam String status,
                                  @RequestParam String stationId,
                                  @RequestParam double price,
                                  @RequestParam int engineCC,
                                  @RequestParam String fuelType,
                                  @RequestParam(defaultValue = "false") boolean licenseRequired,
                                  @RequestParam(defaultValue = "true")  boolean helmetProvided,
                                  @RequestParam String motoClass,
                                  HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        boolean ok = bikeService.updateMotoBike(bikeId, bikeModel, status, stationId,
                price, engineCC, fuelType, licenseRequired, helmetProvided, motoClass);
        return "redirect:/bikes/edit/" + bikeId + (ok ? "?success=1" : "?error=1");
    }

    /** Fallback generic edit (keeps backward compat) */
    @PostMapping("/edit")
    public String updateBike(@RequestParam String bikeId,
                             @RequestParam String bikeModel,
                             @RequestParam String status,
                             @RequestParam String stationId,
                             @RequestParam double price,
                             HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        bikeService.updateBike(bikeId, bikeModel, status, stationId, price);
        return "redirect:/bikes";
    }

    // ─── ADMIN: Delete Bike ──────────────────────────────────────────────────────

    @PostMapping("/delete")
    public String deleteBike(@RequestParam String bikeId, HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        bikeService.deleteBike(bikeId);
        return "redirect:/bikes";
    }
}
