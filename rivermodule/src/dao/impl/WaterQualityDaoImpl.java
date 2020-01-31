package dao.impl;

import dao.WaterQualityDao;
import domain.Statistics;
import domain.WaterQuality;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-20 15:05
 */
public class WaterQualityDaoImpl implements WaterQualityDao
{
    private JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());

    @Override
    public boolean add(WaterQuality waterQuality)
    {

        int update=0;
        try {
            String sql="insert into water_quality (belongStation,dateTime,pH,DO,NH4,CODMn,TOC,level) values (?,?,?,?,?,?,?,?)";
            update = template.update(sql, waterQuality.getBelongStation(),
                    waterQuality.getDateTime(), waterQuality.getpH(), waterQuality.getdO(), waterQuality.getnH4(),
                    waterQuality.getcODMn(), waterQuality.gettOC(), waterQuality.getLevel());
        } catch (DataAccessException e) {
            e.printStackTrace();
        }
        if(update==0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    @Override
    public List<WaterQuality> findByName(String stationName)
    {
        List<WaterQuality> list=null;
        try
        {
            String sql="select * from water_quality where belongStation=?";
            list = template.query(sql, new BeanPropertyRowMapper<WaterQuality>(WaterQuality.class), stationName);
        } catch (Exception e)
        {
            System.out.println(e);
        }
        return list;
    }

    @Override
    public boolean update(WaterQuality waterQuality)
    {
        int update=0;
        try
        {
            String sql="update water_quality set belongStation=?,dateTime=?,pH=?,DO=?,NH4=?,CODMn=?,TOC=?,level=?  where id=?";
            update = template.update(sql, waterQuality.getBelongStation(),
                    waterQuality.getDateTime(), waterQuality.getpH(), waterQuality.getdO(), waterQuality.getnH4(),
                    waterQuality.getcODMn(), waterQuality.gettOC(), waterQuality.getLevel(), waterQuality.getId());
        } catch (Exception e)
        {
            System.out.println(e);
        }
        return update!=0;
    }

    @Override
    public boolean del(int id)
    {
        int update=0;
        try
        {
            String sql="delete from water_quality where id=?";
            update = template.update(sql, id);
        } catch (Exception e)
        {
            System.out.println(e);
        }
        return update!=0;
    }

    @Override
    public WaterQuality findNewestRecord(String stationName)
    {
        WaterQuality waterQuality = null;
        try
        {
            String sql="SELECT * FROM water_quality WHERE belongStation=? ORDER BY DATETIME DESC LIMIT 1";
            waterQuality = template.queryForObject(sql, new BeanPropertyRowMapper<WaterQuality>(WaterQuality.class),stationName);
        } catch (Exception e)
        {
            System.out.println(e);
        }
        return waterQuality;
    }


}
