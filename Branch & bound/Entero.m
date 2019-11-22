function [s,f]=Entero(x)
  
  n=size(x,1); %número de variaveis
  u=x<0.01;%se a variaveis x é menor que uma tolerancia então é aproximadamente 0
  x(u)=0; %definira variavel em zero
  s=single(x);%tirar os decimais das variaveis para que 1000 seja igual a 1
  f=[];%vetor de variaveis 1 se é inteiro y 0 se é outro valor
  for i=1:1:n %repita o processo até o número de variaveis
    if mod(x(i),1)==0% se o modulo igual é igual a zero
      f(i)=1;% a variavel x(i) é inteira
    else
      f(i)=0;%a variavel x(i) é inteira
    endif
  endfor
  if sum(f)==n % se a soma d f é igual a um número de variaveis inteiras todas são inteiras
    s=1;%s=1 quer decidir que todas as variaveis são inteiras
  endif
endfunction
