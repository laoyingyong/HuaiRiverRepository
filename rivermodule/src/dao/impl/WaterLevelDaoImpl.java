package dao.impl;

import dao.WaterLevelDao;
import domain.PageBean;
import domain.WaterLevel;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class WaterLevelDaoImpl implements WaterLevelDao
{
    JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());
    @Override
    public List<WaterLevel> findAllByPage(int start,int pageSize)
    {

        String sql="select * from water_level limit ?,?";
        List<WaterLevel> list = template.query(sql, new BeanPropertyRowMapper<WaterLevel>(WaterLevel.class),start,pageSize);
        return list;
    }

    @Override
    public int findAllCount()
    {
        String sql="select count(*) from water_level";
        int integer = template.queryForObject(sql, Integer.class);
        return integer;

    }

    @Override
    public boolean addWaterLevelInfo(WaterLevel waterLevel)
    {
        String sq="select * from water_level where siteName=? and collectionDate=?";
        List<WaterLevel> query=null;
        try {
            query = template.query(sq, new BeanPropertyRowMapper<WaterLevel>(WaterLevel.class), waterLevel.getSiteName(), waterLevel.getCollectionDate());
        } catch (Exception e) {
            System.out.println(e);
        }
        int update=0;
        if(query==null||query.size()==0)
        {
            try {
                String sql="insert into water_level (id,riverName,siteName,collectionDate,waterLevel,flow,over) values(null,?,?,?,?,?,?)";
                update = template.update(sql, waterLevel.getRiverName(),
                        waterLevel.getSiteName(),
                        waterLevel.getCollectionDate(),
                        waterLevel.getWaterLevel(),
                        waterLevel.getFlow(),
                        waterLevel.getOver());
            } catch (Exception e) {
                System.out.println(e);
            }

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
    public boolean update(WaterLevel waterLevel)
    {
        int update=0;
        try {
            String sql="update water_level set riverName=?,siteName=?,collectionDate=? ,waterLevel=?,flow=?,over=? where id=?";
            update = template.update(sql,
                    waterLevel.getRiverName(),
                    waterLevel.getSiteName(),
                    waterLevel.getCollectionDate(),
                    waterLevel.getWaterLevel(),
                    waterLevel.getFlow(),
                    waterLevel.getOver(),
                    waterLevel.getId());
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
    public boolean deleteInfo(int id)
    {
        int update=0;
        try {
            String sql="delete from water_level where id=?";
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

    @Override
    public List<WaterLevel> conditionalQueryByPage(int start, int pageSize, Map<String,String[]> condition)
    {

        StringBuilder builder=new StringBuilder();//代表整个sql语句
        String starStr="select * from water_level where 1=1 ";
        builder.append(starStr);

        List<Object> valueList=new ArrayList<>();

        //遍历map集合
        for(String key:condition.keySet())
        {

            //排除分页条件参数
            if("currentPage2".equals(key) || "pageSize2".equals(key))
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
        System.out.println(Arrays.toString(valueList.toArray()));

        //执行sql
        List<WaterLevel> objList = null;
        try {
            objList = template.query(sql, new BeanPropertyRowMapper<WaterLevel>(WaterLevel.class), valueList.toArray());
        } catch (Exception e) {
            System.out.println(e);
        }

        return objList;
    }

    @Override
    public int conditionalFindAllCount(Map<String, String[]> condition)//条件查询的总记录数
    {
        StringBuilder builder=new StringBuilder();//代表整个sql语句
        String starStr="select count(*) from water_level where 1=1 ";
        builder.append(starStr);

        List<Object> valueList=new ArrayList<>();

        //遍历map集合
        for(String key:condition.keySet())
        {

            //排除分页条件参数
            if("currentPage2".equals(key) || "pageSize2".equals(key))
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
        } catch (Exception e) {
            System.out.println(e);
        }


        return integer;
    }

    @Override
    public List<WaterLevel> findBySiteName(String siteName)
    {
        List<WaterLevel> query = null;
        try {
            String sql="SELECT *  FROM water_level WHERE siteName=? ORDER BY collectionDate";
            query = template.query(sql, new BeanPropertyRowMapper<WaterLevel>(WaterLevel.class), siteName);
        } catch (Exception e) {
            System.out.println(e);
        }
        return query;
    }

    @Override
    public List<WaterLevel> findWeekData()
    {
        List<WaterLevel> query = null;
        try {
            String sql="SELECT * FROM water_level WHERE TO_DAYS(NOW())-TO_DAYS(collectionDate)<=6 ORDER BY collectionDate DESC;";
            query = template.query(sql, new BeanPropertyRowMapper<WaterLevel>(WaterLevel.class));
        } catch (Exception e) {
            System.out.println(e);
        }
        return query;
    }
}
