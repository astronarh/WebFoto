package ru.astronarh.WebFoto.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import ru.astronarh.WebFoto.dao.ImageDAO;
import ru.astronarh.WebFoto.dao.UserDAO;
import ru.astronarh.WebFoto.model.Image;
import ru.astronarh.WebFoto.model.User;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Controller
public class MainController {

    @Qualifier("getImageDao")
    @Autowired
    private ImageDAO imageDAO;

    @Autowired
    private UserDAO userDAO;

    @RequestMapping("/")
    public ModelAndView index(/*Locale locale*/)
    {
        //System.out.println(imageDAO.list());
        //imageDAO.saveOrUpdate(new Image("new image", "the butes"));
        //imageDAO.delete(2);
        //System.out.println(imageDAO.get(1));

        ModelAndView view = new ModelAndView("index");
        view.addObject("image", new Image("1", "2", 1));

        User user = getCurrentUser();
        if(user != null) {
            List<Image> imageList = imageDAO.listByUserId((int) user.getId());
            view.addObject("imageList", imageList);
            view.addObject("numberOfImages", imageList.size());
        }

        return view;
    }

    @RequestMapping("/login-successful")
    public ModelAndView loginSuccessful()
    {
        ModelAndView view = new ModelAndView("index");
        view.addObject("loginMessage", "You are login as");
        view.addObject("image", new Image("1", "2", 1));
        return view;
    }

    @RequestMapping("/logout")
    public ModelAndView logout()
    {
        ModelAndView view = new ModelAndView("index");
        view.addObject("loginMessage", "You are login as");
        view.addObject("image", new Image("1", "2", 1));
        return view;
    }

    @RequestMapping(value = "/saveImage", method = RequestMethod.POST)
    public String saveImage(@ModelAttribute("image") Image image, Model model) {
        User user = getCurrentUser();
        image.setUser_id((int) user.getId());
        model.addAttribute("name", image.getName());
        model.addAttribute("bytes", image.getBytes());
        System.out.println(image);
        imageDAO.saveOrUpdate(image);
        return "image";
    }

    @RequestMapping(value="/images/{imgCounter}", method=RequestMethod.GET)
    @ResponseBody
    public List<Image> getAllImages(@PathVariable int imgCounter){
        System.out.println("/images/" + imgCounter);
        List<Image> imageList = imageDAO.listByUserId((int) getCurrentUser().getId()).subList(imgCounter, imgCounter + 4);
        for (Image x : imageList) System.out.println(x.getId());
        return imageList;
    }

    private User getCurrentUser() {
        try {
            Authentication authentication= SecurityContextHolder.getContext().getAuthentication();
            UserDetails userDetails = (UserDetails)authentication.getPrincipal();
            String username = userDetails.getUsername();
            return userDAO.getByLogin(username);
        } catch (Exception e) {
            e.fillInStackTrace();
            return null;
        }
    }

    @RequestMapping(value = "/deleteImage/{id}", method = RequestMethod.GET)
    @ResponseBody
    public void deleteImage(@PathVariable int id) {
        imageDAO.delete(id);
    }
}
