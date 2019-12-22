package dao.impl;

import dao.GraphDao;
import domain.Graph;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.List;

public class GraphDaoImpl implements GraphDao
{
    JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());
    @Override
    public boolean addInfo(Graph graph)
    {
        int update=0;
        try
        {
            String sql="insert into graph values (null,?,?,?)";
            update = template.update(sql, graph.getName(), graph.getCity(), graph.getGeometry());
        } catch (DataAccessException e)
        {
            System.out.println(e);
        }
        if(update!=0)
        {
            return true;
        }
        else
        {
            return false;
        }

    }

    @Override
    public List<Graph> queryInfo()
    {
        List<Graph> list=null;
        try
        {
            String sql="select * from graph";
            list = template.query(sql, new BeanPropertyRowMapper<Graph>(Graph.class));
        } catch (DataAccessException e)
        {
            System.out.println(e);
        }
        return list;
    }

    @Override
    public boolean deleGraph(int id)
    {
        int update=0;
        try {
            String sql="delete from graph where id=?";
            update = template.update(sql, id);
        } catch (DataAccessException e) {
            e.printStackTrace();
        }
        if(update!=0)
        {
            return true;
        }
        else
        {
            return false;
        }

    }
}
