package dao.impl;

import dao.RainFallDao;
import domain.RainFall;
import domain.WaterLevel;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class RainFallDaoImpl implements RainFallDao
{
    JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());

    @Override
    public List<RainFall> findAll()
    {
        String sql="select * from rain_fall";
        List<RainFall> list = template.query(sql, new BeanPropertyRowMapper<RainFall>(RainFall.class));
        return list;
    }

    @Override
    public boolean addRainFallInfo(RainFall rainFall)
    {
        int update=0;
        try {
            String sql="insert into rain_fall values(null,?,?,?,?)";
            update = template.update(sql, rainFall.getArea(), rainFall.getPrecipitation(), rainFall.getMonth(), rainFall.getReleaseDate());
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

    @Override
    public List<RainFall> conditonalQueryByPage(int start, int pageSize, Map<String, String[]> condition)
    {
        StringBuilder builder=new StringBuilder();//代表整个sql语句
        String starStr="select * from rain_fall where 1=1 ";
        builder.append(starStr);

        List<Object> valueList=new ArrayList<>();

        //遍历map集合
        for(String key:condition.keySet())
        {

            //排除分页条件参数
            if("currentPage".equals(key) || "pageSize".equals(key))
            {
                continue;
            }


            String value = condition.get(key)[0];
            if(value!=null&&!"".equals(value))
            {
                builder.append(" and "+key+" like ? ");
                valueList.add("%"+value+"%");

            }
        }


        builder.append(" limit ?,? ");
        valueList.add(start);
        valueList.add(pageSize);
        String sql = builder.toString();

        System.out.println(sql);
        System.out.println(valueList);

        //执行sql
        List<RainFall> objList = null;
        try {
            objList = template.query(sql, new BeanPropertyRowMapper<RainFall>(RainFall.class), valueList.toArray());
        } catch (DataAccessException e) {
            System.out.println(e);
        }

        return objList;
    }

    @Override
    public int conditionalFindAllCount(Map<String, String[]> condition)
    {
        StringBuilder builder=new StringBuilder();//代表整个sql语句
        String starStr="select count(*) from rain_fall where 1=1 ";
        builder.append(starStr);

        List<Object> valueList=new ArrayList<>();

        //遍历map集合
        for(String key:condition.keySet())
        {

            //排除分页条件参数
            if("currentPage".equals(key) || "pageSize".equals(key))
            {
                continue;
            }


            String value = condition.get(key)[0];
            if(value!=null&&!"".equals(value))
            {
                builder.append(" and "+key+" like ? ");
                valueList.add("%"+value+"%");

            }
        }
        String sql = builder.toString();
        System.out.println(sql);
        System.out.println(valueList);

        int integer = 0;
        try {
            integer = template.queryForObject(sql, Integer.class, valueList.toArray());
        } catch (DataAccessException e)
        {
            System.out.println(e);
        }


        return integer;

    }
}
