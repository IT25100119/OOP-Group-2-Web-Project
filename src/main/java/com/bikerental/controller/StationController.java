package com.bikerental.controller;

import com.bikerental.model.Station;
import com.bikerental.service.StationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/stations")
public class StationController {

    @Autowired private StationService stationService;

    @GetMapping
    public String listStations(@RequestParam(required = false) String search,
                               Model model, HttpSession session) {
        if (search != null && !search.isBlank()) {
            model.addAttribute("stations", stationService.searchByLocation(search));
            model.addAttribute("search", search);
        } else {
            model.addAttribute("stations", stationService.getAllStations());
        }
        model.addAttribute("sessionAdmin", session.getAttribute("loggedAdmin"));
        return "stations/list";
    }

    @GetMapping("/add")
    public String addPage(HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        return "stations/add";
    }

    @PostMapping("/add")
    public String addStation(@RequestParam String name,
                             @RequestParam String location,
                             @RequestParam int maxCapacity,
                             @RequestParam(defaultValue = "0.0") double latitude,
                             @RequestParam(defaultValue = "0.0") double longitude,
                             HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        stationService.addStation(name, location, maxCapacity, latitude, longitude);
        model.addAttribute("success", "Station added successfully.");
        return "redirect:/stations";
    }

    @GetMapping("/edit/{stationId}")
    public String editPage(@PathVariable String stationId, HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        model.addAttribute("station", stationService.findById(stationId));
        return "stations/edit";
    }

    @PostMapping("/edit")
    public String updateStation(@RequestParam String stationId,
                                @RequestParam String name,
                                @RequestParam String location,
                                @RequestParam int maxCapacity,
                                @RequestParam String operationalStatus,
                                HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        stationService.updateStation(stationId, name, location, maxCapacity, operationalStatus);
        return "redirect:/stations";
    }

    @PostMapping("/delete")
    public String deleteStation(@RequestParam String stationId, HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        stationService.deleteStation(stationId);
        return "redirect:/stations";
    }
}
