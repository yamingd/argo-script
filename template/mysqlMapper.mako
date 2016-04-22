package {{ _tbi_.java.mapper_ns }};

import com.argo.db.SqlMapper;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.db.mysql.TableContext;
import org.springframework.dao.DataAccessException;

import java.util.List;

{% for r in _tbi_.impJavas %}
import {{ r.model_ns }}.{{ r.name }};
{% endfor %}

import {{ _tbi_.java.model_ns }}.{{_tbi_.java.name}};

/**
 * Created by {{_user_}}.
 */
public interface {{_tbi_.java.name}}Mapper extends SqlMapper<{{_tbi_.java.name}}, {{_tbi_.pk.java.typeName}}> {

{% for rc in _tbi_.refFields %}
	/**
     * 关联 {{rc.java.nameC}}
     * @param context
     * @param item
     * @throws DataAccessException
     * @throws EntityNotFoundException
     */
{% if rc.java.repeated %}    
    List<{{rc.java.refJava.name}}> wrap{{rc.java.nameC}}(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException, EntityNotFoundException;
{% else %}
    {{rc.java.refJava.name}} wrap{{rc.java.nameC}}(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException, EntityNotFoundException;
{% endif %}
    /**
     * 关联 {{rc.java.nameC}}
     * @param context
     * @param list
     * @throws DataAccessException
     */
    List<{{rc.java.refJava.name}}> wrap{{rc.java.nameC}}(TableContext context, List<{{_tbi_.java.name}}> list) throws DataAccessException;
    
{% endfor %}

}