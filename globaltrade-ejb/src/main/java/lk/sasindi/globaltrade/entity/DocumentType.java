package lk.sasindi.globaltrade.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "document_type")
public class DocumentType implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(
            name = "name",
            nullable = false,
            length = 45
    )
    private String name;

    @OneToMany(
            mappedBy = "documentType",
            fetch = FetchType.LAZY
    )
    private List<CustomDocument> customDocuments =
            new ArrayList<>();


    public DocumentType() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public List<CustomDocument> getCustomDocuments() {
        return customDocuments;
    }

    public void setCustomDocuments(
            List<CustomDocument> customDocuments
    ) {
        this.customDocuments = customDocuments;
    }
}