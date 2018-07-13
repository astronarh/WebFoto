package ru.astronarh.WebFoto.dao;

import ru.astronarh.WebFoto.model.Image;

import java.util.List;

public interface ImageDAO {
    List<Image> list();

    List<Image> listByUserId(int userId);

    Image get(int id);

    void saveOrUpdate(Image image);

    void delete(int id);
}
