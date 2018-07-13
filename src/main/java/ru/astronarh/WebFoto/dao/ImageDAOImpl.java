package ru.astronarh.WebFoto.dao;

import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import ru.astronarh.WebFoto.model.Image;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

@Repository
public class ImageDAOImpl implements ImageDAO {

    private JdbcTemplate jdbcTemplate;

    public ImageDAOImpl(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    @Transactional
    public List<Image> list() {
        String sql = "SELECT * FROM images";
        List<Image> imageList = jdbcTemplate.query(sql, new RowMapper<Image>() {

            @Override
            public Image mapRow(ResultSet rs, int rowNum) throws SQLException {
                Image aImage = new Image();

                aImage.setId(rs.getInt("id"));
                aImage.setName(rs.getString("name"));
                aImage.setBytes(rs.getString("bytes"));
                aImage.setUser_id(rs.getInt("user_id"));

                return aImage;
            }

        });

        return imageList;
    }

    @Override
    @Transactional
    public List<Image> listByUserId(int userId) {
        String sql = "SELECT * FROM images WHERE user_id=" + userId;
        return jdbcTemplate.query(sql, new RowMapper<Image>() {
            @Override
            public Image mapRow(ResultSet rs, int rowNum) throws SQLException {
                Image aImage = new Image();
                aImage.setId(rs.getInt("id"));
                aImage.setName(rs.getString("name"));
                aImage.setBytes(rs.getString("bytes"));
                aImage.setUser_id(rs.getInt("user_id"));
                return aImage;
            }
        });
    }

    @Override
    public Image get(int id) {
        String sql = "SELECT * FROM images WHERE id=" + id;
        return jdbcTemplate.query(sql, new ResultSetExtractor<Image>() {

            @Override
            public Image extractData(ResultSet rs) throws SQLException,
                    DataAccessException {
                if (rs.next()) {
                    Image image = new Image();
                    image.setId(rs.getInt("id"));
                    image.setName(rs.getString("name"));
                    image.setBytes(rs.getString("bytes"));
                    image.setUser_id(rs.getInt("user_id"));
                    return image;
                }

                return null;
            }

        });
    }

    @Override
    public void saveOrUpdate(Image image) {
        if (image.getId() > 0) {
            // update
            String sql = "UPDATE images SET name=?, bytes=?, user_id=? WHERE id=?";
            jdbcTemplate.update(sql, image.getName(), image.getBytes(), image.getUser_id(), image.getId());
        } else {
            // insert
            String sql = "INSERT INTO images (name, bytes, user_id) VALUES (?, ?, ?)";
            jdbcTemplate.update(sql, image.getName(), image.getBytes(), image.getUser_id());
        }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM images WHERE id=?";
        jdbcTemplate.update(sql, id);
    }
}
