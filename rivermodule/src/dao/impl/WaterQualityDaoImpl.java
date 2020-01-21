package dao.impl;

import dao.WaterQualityDao;
import domain.WaterQuality;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

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


}
