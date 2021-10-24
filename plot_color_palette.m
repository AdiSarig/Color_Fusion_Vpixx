load color_palette_macbook_pro_2018

figure
img = [1:15;16:30];
image(img)
colormap([reds;greens])
set(gca,'xtick',[],'ytick',[])

figure
img2 = [15:-1:1,16:30];
image(img2)
colormap([reds;greens])
set(gca,'xtick',[],'ytick',[])

img3 = fliplr(img2);
figure
image(img3)
colormap([reds;greens])
set(gca,'xtick',[],'ytick',[])

