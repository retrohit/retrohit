package com.retrohit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Controller
public class MovieController {

    private final List<String> movies = Arrays.asList(
        "Bramayugam", "Gone Girl", "Nayakan", "Oz", "Ford vs Ferrari",
        "The Truman Show", "Dial M For Murder", "Home", "Kadasai Vivasayi",
        "Old Boy", "Requiem for a Dream", "12 Angry Men", "It's a Wonderful Life"
    );

    private final Random random = new Random();

    @GetMapping("/")
    public String showMovie(Model model) {
        int index = random.nextInt(movies.size());
        model.addAttribute("movie", movies.get(index));
        return "index";
    }
}
