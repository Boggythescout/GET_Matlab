clear all

%%Bis zur ersten Querlinie können Einstellungen für das Feld vorgenommen
%%werden. Es können beliebig viele Ladungen eingebaut werden. Es müssen nur
%%im ersten Abschnitt die "%Ladungx" kopiert und die Namen mit neuen
%%Nummern versehen werden (siehe Ladung 1-5). Im zweiten Abschnitt muss dann ein neues struct
%%aus der neuen Ladung erstellt werden (siehe Ladung 1-5)
%%

%Vorfaktor für das Feld  
%Elektrostatisch: (1/4*pi*8,854*10^-12)
vorfaktor=(1/4*pi*8.854*10^-12);


%Anzahl der ausgefüllten Ladungen
anzahlLadungen=3

%Ladung1 (POSITIV)
x_ort_1=-6;
y_ort_1=3;
wert_1=10;
posi1=zeros(4)
farbe1='w'
name1=['\leftarrow Ladung 1=' num2str(wert_1)]

%Ladung2
x_ort_2=6;
y_ort_2=0;
wert_2=-10;
posi2=zeros(4)
farbe2='w'
name2=['\leftarrow Ladung 2=' num2str(wert_2)]

%Ladung3
x_ort_3=-3;
y_ort_3=-3;
wert_3=30;
posi3=zeros(4)
farbe3='w'
name3=['\leftarrow Ladung 3=' num2str(wert_3)]

%Ladung4
x_ort_4=0;
y_ort_4=0;
wert_4=-3;
posi4=zeros(4)
farbe4='w'
name4=['\leftarrow Ladung 4=' num2str(wert_4)]

%Ladung5
x_ort_5=-4;
y_ort_5=-4;
wert_5=2;
posi5=zeros(4)
farbe5='w'
name5=['\leftarrow Ladung 5=' num2str(wert_5)]

%Feldgröße Darstellung [-x x -y y]
bereich =[-10 10 -10 10]

%Feldgröße Berechnung [x y]
[x,y] = meshgrid(-100:0.1:100,-100:0.1:100);

%Größe Ladung
radius=0.25;

%Dichte der dargestellten Feldlinien
feldlinien=4;

%Ploteinstellungen
%Genauigkeit der Linien
schrittweite =0.4;
%Länge der Linien
menge=100000
%Durchmesser der Startpunkte für die Linien
groese_Startring=0.1


%% Definition Ladungen
xpos='xpos';
ypos='ypos';
wert='wert';
position='posi';
farbe='farbe';
name='name';

Ladung(1)=struct(xpos,x_ort_1,ypos,y_ort_1,wert,wert_1,position,posi1,farbe,farbe1,name,name1)
Ladung(2)=struct(xpos,x_ort_2,ypos,y_ort_2,wert,wert_2,position,posi2,farbe,farbe2,name,name2)
Ladung(3)=struct(xpos,x_ort_3,ypos,y_ort_3,wert,wert_3,position,posi3,farbe,farbe3,name,name3)
Ladung(4)=struct(xpos,x_ort_4,ypos,y_ort_4,wert,wert_4,position,posi4,farbe,farbe4,name,name4)
Ladung(5)=struct(xpos,x_ort_5,ypos,y_ort_5,wert,wert_5,position,posi5,farbe,farbe5,name,name5)

%% Ladungskreise einzeichnen


for t=(1:1:anzahlLadungen)
    if Ladung(t).wert < 0
        Ladung(t).posi=[(Ladung(t).xpos-radius) (Ladung(t).ypos-radius) (radius.*2) (radius.*2) ];
        Ladung(t).farbe='r';
    elseif Ladung(t).wert > 0    
        Ladung(t).posi=[(Ladung(t).xpos-radius) (Ladung(t).ypos-radius) (radius.*2) (radius.*2) ];
        Ladung(t).farbe='b';
    end
end



%% Berechnung der Startpunkte um Ladung 1
for z=(1:1:anzahlLadungen)
    if ((Ladung(z).wert)>0) 
        xs=0
        ys=0
        %Definition Funktionsbereich
        xs=(0:pi/((Ladung(z).wert)*feldlinien):2*pi);
        ys=(0:pi/((Ladung(z).wert)*feldlinien):2*pi);
                
        %Erzeugen des Kreises und Skalierung
        xsuebertrag=cos(xs)*groese_Startring+Ladung(z).xpos;
        ysuebertrag=sin(xs)*groese_Startring+Ladung(z).ypos;
        
        if z==1
            x1s=xsuebertrag;
            y1s=ysuebertrag;
        else   
            x1s=horzcat(x1s, xsuebertrag)
            y1s=horzcat(y1s, ysuebertrag)
        end
    end
end

%% Berechnung des Feldes
u=0
v=0
for k=(1:1:anzahlLadungen)
    u=u+(vorfaktor*Ladung(k).wert./((x-Ladung(k).xpos).^2+(y-Ladung(k).ypos).^2)).*((x-Ladung(k).xpos)./sqrt((x-Ladung(k).xpos).^2+(y-Ladung(k).ypos).^2));
    v=v+(vorfaktor*Ladung(k).wert./((x-Ladung(k).xpos).^2+(y-Ladung(k).ypos).^2)).*((y-Ladung(k).ypos)./sqrt((x-Ladung(k).xpos).^2+(y-Ladung(k).ypos).^2));
    k
end


%% Plot und Anwendung der Ploteinstellungen
einstellungen=[schrittweite menge]

figure
streamline(x,y,u,v,x1s(:),y1s(:),einstellungen)

for l=(1:1:anzahlLadungen)
    rectangle('Position',Ladung(l).posi,'Curvature',[1 1],'FaceColor',Ladung(l).farbe)
    text(Ladung(l).xpos,Ladung(l).ypos,Ladung(l).name,'FontSize',12)
end

axis(bereich)
title('Feldlinien')
legend('Feldlinien')
fertig='fertig'

