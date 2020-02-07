package dao.impl;

import dao.ExampleDao;
import domain.Example;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 13:39
 */
public class ExampleDaoImpl implements ExampleDao
{
    JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());

    @Override
    public List<Example> findResembleExamples()
    {
        List<Example> query = null;
        try {
            String sql="select * from example";
            query = template.query(sql, new BeanPropertyRowMapper<Example>(Example.class));
        } catch (Exception e) {
            System.out.println(e);
        }
        return query;
    }

}
