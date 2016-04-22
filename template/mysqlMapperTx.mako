package {{ _tbi_.java.mapper_impl_ns }};

import org.springframework.transaction.annotation.Transactional;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by {{_user_}}.
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Transactional(value="{{_tbi_.java.package}}Tx", rollbackFor=Exception.class)
public @interface {{_tbi_.java.name}}Tx {
}
