function [s,f]=Entero(x)
  
  n=size(x,1); %n�mero de variaveis
  u=x<0.01;%se a variaveis x � menor que uma tolerancia ent�o � aproximadamente 0
  x(u)=0; %definira variavel em zero
  s=single(x);%tirar os decimais das variaveis para que 1000 seja igual a 1
  f=[];%vetor de variaveis 1 se � inteiro y 0 se � outro valor
  for i=1:1:n %repita o processo at� o n�mero de variaveis
    if mod(x(i),1)==0% se o modulo igual � igual a zero
      f(i)=1;% a variavel x(i) � inteira
    else
      f(i)=0;%a variavel x(i) � inteira
    endif
  endfor
  if sum(f)==n % se a soma d f � igual a um n�mero de variaveis inteiras todas s�o inteiras
    s=1;%s=1 quer decidir que todas as variaveis s�o inteiras
  endif
endfunction
