package monedas.api.aplicacion.servicios;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import monedas.api.core.servicios.*;
import monedas.api.core.repositorios.*;
import monedas.api.dominio.entidades.*;
import monedas.api.dominio.dtos.*;

@Service
public class PaisServicio implements IPaisServicio {

    @Autowired
    private IPaisRepositorio repositorio;


    @Override
    public List<Pais> listar() {
        return repositorio.listar();
    }

    @Override
    public Pais obtener(int id) {
        return repositorio.obtenerPorId(id).orElse(null);
    }

    @Override
    public List<Pais> buscar(String nombre) {
        return repositorio.buscarPorNombre(nombre);
    }

    @Override
    public Pais agregar(Pais pais) {
        pais.setId(0);
        return repositorio.guardar(pais);
    }

    @Override
    public Pais modificar(Pais pais) {
        var paisEncontrado = repositorio.obtenerPorId(pais.getId());
        return paisEncontrado.isEmpty() ? null : repositorio.guardar(pais);
    }

    public boolean eliminar(int id) {
        return repositorio.eliminar(id);
    }


}
