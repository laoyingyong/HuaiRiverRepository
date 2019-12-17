package service.impl;

import dao.WaterQualityStationDao;
import dao.impl.WaterQualityStationDaoImpl;
import domain.PageBean;
import domain.WaterQualityStation;
import service.WaterQualityStationService;

import java.util.List;
import java.util.Map;

public class WaterQualityStationServiceImpl implements WaterQualityStationService
{
    WaterQualityStationDao dao=new WaterQualityStationDaoImpl();

    /**
     * 查询所有水质监测站
     * @return
     */
    @Override
    public int findTotalCount()
    {
        int totalCount = dao.findTotalCount();
        return totalCount;
    }

    @Override
    public WaterQualityStation findIntroByName(String name) {
        return dao.findIntroByName(name);
    }

    @Override
    public boolean addWaterQualityStation(WaterQualityStation station)
    {
        return dao.addWaterQualityStation(station);

    }

    @Override
    public PageBean<WaterQualityStation> getPageBean(int currentPage, int pageSize)
    {
        PageBean<WaterQualityStation> pageBean=new PageBean<>();
        int totalCount=dao.findTotalCount();
        pageBean.setTotalCount(totalCount);
        int totalPage=totalCount%pageSize==0?totalCount/pageSize:(totalCount/pageSize+1);
        pageBean.setTotalPage(totalPage);
        pageBean.setCurrentPage(currentPage);
        pageBean.setRows(pageSize);
        int start=(currentPage-1)*pageSize;
        List<WaterQualityStation> list = dao.findByPage(start, pageSize);
        pageBean.setList(list);
        return pageBean;
    }

    @Override
    public WaterQualityStation findIntroById(int id)
    {
        WaterQualityStation introById = dao.findIntroById(id);
        return introById;
    }

    @Override
    public PageBean<WaterQualityStation> conditonalQueryByPage(int currentPage, int pageSize, Map<String, String[]> condition)
    {
        PageBean<WaterQualityStation> pageBean=new PageBean<>();
        int totalCount= dao.conditionalFindAllCount(condition);
        pageBean.setTotalCount(totalCount);
        int totalPage=totalCount%pageSize==0?totalCount/pageSize:(totalCount/pageSize+1);
        pageBean.setTotalPage(totalPage);
        pageBean.setCurrentPage(currentPage);
        pageBean.setRows(pageSize);
        List<WaterQualityStation> list = dao.conditonalQueryByPage((currentPage - 1) * pageSize, pageSize, condition);
        pageBean.setList(list);
        return pageBean;
    }

    @Override
    public int conditionalFindAllCount(Map<String, String[]> condition)
    {
        int i = dao.conditionalFindAllCount(condition);
        return i;
    }

    @Override
    public boolean update(WaterQualityStation station)
    {
        boolean b = dao.update(station);
        return b;
    }

    @Override
    public boolean delete(int id)
    {
        boolean b = dao.delete(id);
        return b;
    }
}
