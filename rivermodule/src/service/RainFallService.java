package service;

import domain.PageBean;
import domain.RainFall;

import java.util.List;
import java.util.Map;

public interface RainFallService
{
    public abstract List<RainFall> findAll();
    public abstract boolean addRainFallInfo(RainFall rainFall);
    public abstract PageBean<RainFall> conditonalQueryByPage(int currentPage, int pageSize, Map<String,String[]> condition);
    public abstract int conditionalFindAllCount(Map<String, String[]> condition);
    public abstract boolean updateRainFallInfo(RainFall rainFall);

}
