package com.brtwc.users_demo_backend;

import org.springframework.data.repository.CrudRepository;

import com.brtwc.users_demo_backend.User;

public interface UserRepository extends CrudRepository<User, Integer> {

}