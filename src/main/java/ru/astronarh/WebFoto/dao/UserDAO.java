package ru.astronarh.WebFoto.dao;


import ru.astronarh.WebFoto.model.User;

public interface UserDAO {
    User getByLogin(String login);
}
