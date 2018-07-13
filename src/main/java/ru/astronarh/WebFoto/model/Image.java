package ru.astronarh.WebFoto.model;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "images")
public class Image {

    @Id
    @Column(name = "id", columnDefinition = "serial")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator="images_id_seq")
    @SequenceGenerator(name="images_id_seq", sequenceName="images_id_seq", allocationSize=1)
    private long id;

    @Basic
    @Column(name = "name")
    private String name;

    @Basic
    @Column(name = "bytes")
    private String bytes;

    @Basic
    @Column(name = "user_id")
    private int user_id;

    @Basic
    @Column(name = "created_at")
    private Timestamp created_at;

    public Image(String name, String bytes, int user_id) {
        this.name = name;
        this.bytes = bytes;
        this.user_id = user_id;
    }

    public Image() {
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getBytes() {
        return bytes;
    }

    public void setBytes(String bytes) {
        this.bytes = bytes;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return "Image{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", bytes='" + bytes + '\'' +
                ", user_id=" + user_id +
                ", created_at=" + created_at +
                '}';
    }
}
