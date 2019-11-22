%% problema para resolver
f=[-9 -5 -6 -4]; %contantes da função objetivo

A=[6 3 5 2;
   0 0 1 1;
   -1 0 1 0;
   0 -1 0 1]; %% matriz com as inequações

B=[10;
   1;
   0;
   0];

Lb=zeros(4, 10); %%limite inferior
Ub=ones(4,1);%limite superior

[x, fval, exitFlag]=glpk(f,A,B,[],[],Lb, Ub)

%% inicio do programa

N = size(f,2); %numero de variaveis
[s,fx] = Entero(x) % retorne se os valores são inteiros e quais são inteiros
nivel=1; %nivel da árvore

k=1;

while nivel<N+1
  
  i=0;
  j=1;
  r=0;
  tam=2^nivel; %variaveis para sondar
  while i<tam % dependendo do nivel se intera muitas vezes mais
    if mod(i,2)==0 && nivel>1 %se deve mantes os limites de dados definidos 
      if Dados(nivel-1,j).s == 1 %então se encontra variaveis binarias
        r=1; %problema nao sondado se deve buscar mas nessas ramas 
        j=j+1;
      else
        Lb=Dados(nivel-1,j).Lb;%definir a condição minima das variaveis
        Ub=Dados(nivel-1).Ub;%definir a condição maxima das variaveis
        j=j+1;%contados de estados passados
      endif
    endif
    i=i+1;%contador de variaveis limitadas
    if r==1 %não se deve buscar mais nessas ramas
      Dados(nivel,i)=struct('x',0,'fval',0,'exitFlag',0,'Lb',0,'Ub',0,'s',1,'r',1)
      i=i+1;%se você deve dimensionar nos dois ramos filiais
      Dados(nivel,1)=struct('x',0,'fval',0,'exitFlag',0,'Lb',0,'Ub',0,'s',1,'r',1)
    else
      if mod(i,2)~=0 %se d i é ímpar, você deve limitar a variável a zero 
        Lb(k)=0;
        Ub(k)=0;
        [x,fval,exitFlag]=linprog(f,A,B,[],[],Lb,Ub)
        [s,fx]=Entero(x)
        if single(exitFlag) ~= -2
          Dados(nivel,i)=struct('x',x,'fval',fval,'exitFlag',exitFlag,'Lb',Lb,'Ub',Ub,'s',s,'r',0)%estrutura para guardar os dados
        else
          Dados(nivel,1)=struct('x',x,'fval',fval,'exitFlag',exitFlag,'Lb',Lb,'Ub',Ub,'s',1,'r',0)
        endif %se i é par inteiro deve dimensionar
      else
        Lb(k)=1; 
        Ub(k)=1;
        [x,fval,exitFlag]=linprog(f,A,B,[],[],Lb,Ub)%retorna se os valores sao inteiros
        [s,fx]=Entero(x)%se o problema tem problema de dimensão
        if single(exitFlag) ~= -2 %estrutura para guardar os dados
          Dados(nivel,i)=struct('x',x,'fval',fval,'exitFlag',exitFlag,'Lb',Lb,'Ub',Ub,'s',s,'r',0)
        else
          Dados(nivel,i)=struct('x',0,'fval',0,'exitFlag',exitFlag,'Lb',Lb,'Ub',Ub,'s',s,'r',0)
        endif
      endif
    endif
    r=0; 
  endwhile

  for ki=1:1:tam %recorrer a arvore como criterio de saída
    Fun(1,ki)=Dados(nivel,ki).fval %guadar em um vetor Fun o valor da função objetivo
    Fun(2,ki)=Dados(nivel,ki).exitFlag %guardar em um vetor Fun o valor de exitFlag
    if single(Fun(2,ki)) == -2
      Fun(3,ki)=2;
    else
      Fun(3,ki)= Dados(nivel,ki).s %guardar em um vetor Fun o valor da variavel
    endif
    Xdat(ki,:)=Dados(nivel,ki).x 
  endfor
  t= Fun(3,:) ==1 %quais são os valores que cuprem com as variaveis inteiras
  Fun1=Fun(:,t)%%tira os valores das funções que cumprem com a condição de variaveis
  Xint=Xdat(t,:)%extrae o vetor da variavel
  [Fint,d]=min(Fun1(1,:))%valor minimo da função objetivo inteira
  Fint=Fun1(:,d)%salva o valor em Fint
  Xint=Xint(d,:)%salva o valor das variaveis
  
  Fun2=Fum(:,~t)
  Xint=Xdar(~t,:)
  [FNint,d]=min(Fun2(1,:))%valor minimo da função objetivo inteira
  FNint=Fun2(:,d);%salva o valor da variavel
  
  if nivel == 1
    FintV=Fint;
    XintV=Xint;
    
  endif
  if Fint(1,1)<FintV(1,1)
    FintV=Fint;
    XintV=Xint;
    
  endif
  if Fint(1,1)<FNint(1,1)
    break
  endif
  nivel=nivel+1; %contador de niveis
  k=k+1; %contador de variaveis
endwhile

