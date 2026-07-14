package springboot_docker_app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import springboot_docker_app.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {

}