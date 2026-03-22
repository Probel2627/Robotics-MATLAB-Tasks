function R = info_matrix(line_U, line_V, line_W)
    u = [line_U.XData(2)-line_U.XData(1); line_U.YData(2)-line_U.YData(1); line_U.ZData(2)-line_U.ZData(1)];
    v = [line_V.XData(2)-line_V.XData(1); line_V.YData(2)-line_V.YData(1); line_V.ZData(2)-line_V.ZData(1)];
    w = [line_W.XData(2)-line_W.XData(1); line_W.YData(2)-line_W.YData(1); line_W.ZData(2)-line_W.ZData(1)];
    
    u = u / norm(u);
    v = v / norm(v);
    w = w / norm(w);

    R = [u, v, w];
end