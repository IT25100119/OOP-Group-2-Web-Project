package com.bikerental.controller;

import com.bikerental.service.BikePackageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Handles admin CRUD for rental packages (hour blocks and day blocks).
 * All endpoints require an active admin session.
 */
@Controller
@RequestMapping("/bikes/packages")
public class BikePackageController {

    @Autowired private BikePackageService packageService;

    /**
     * Bulk-save all packages for a bike from the edit form.
     * Replaces all existing packages with the submitted set.
     */
    @PostMapping("/save")
    public String savePackages(@RequestParam String bikeId,
                               @RequestParam(required = false) List<String>  pkgType,
                               @RequestParam(required = false) List<Integer> pkgDuration,
                               @RequestParam(required = false) List<Double>  pkgPrice,
                               HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";

        packageService.savePackagesForBike(bikeId, pkgType, pkgDuration, pkgPrice);
        return "redirect:/bikes/edit/" + bikeId + "?success=1";
    }

    /**
     * Delete a single package.
     */
    @PostMapping("/delete")
    public String deletePackage(@RequestParam String packageId,
                                @RequestParam String bikeId,
                                HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        packageService.deletePackage(packageId);
        return "redirect:/bikes/edit/" + bikeId + "?success=1";
    }
}
