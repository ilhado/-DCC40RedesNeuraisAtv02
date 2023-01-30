% DCC40 - Atividade 02
% Reconhecimento de padrões via RNA - Questão 3 

% Definições:
% numTreinamentos - acumulará a quantidade de treinamentos
% O número máximo de treinamentos será .
% Fase 1 - 10 treinamentos com reinicilização aleatória dos pesos a cada treino
% Fase 2 - 10 treinamentos com reinicialiação aleatória dos pesos a cada treino com
% variação da função de ativação dos neurônios escondidos a cada 10 treinos
% Fase 3 - 10 treinamentos com reinicialização aleatória dos pesos a cada treino com
% variação na quantidade de neurônios escondidos a cada 10 treinamentos, 
% em um total de 10 variações nessa quantidade, perfazendo um total de 
% 100 treinamentos 
% Fase 4 - 10 treinamentos com reinicialização aleatória dos pesos a cada treino com
% variação na taxa de aprendizado a cada 10 treinamentos, em um total de cinco variações nessa taxa
% perfazendo um total de 50 treinamentos


% Cada treinamento terá 10 épocas.
%

% Lista de módulos
% 1 - Leitor da base de dados
% 2 - Execução inicial


% 1 - Leitor da base de dados

linhasBaseOriginal = readlines("C:\Users\oficial\Documents\DCCMAPI\Atv02\car.data");
baseOriginal = -1 .* ones(length(linhasBaseOriginal)-1 ,7);

for i=1:length(linhasBaseOriginal)-1
    partesLinha = split(linhasBaseOriginal(i,1),",");
    for j=1:7
        if (partesLinha(j,1) == "low" || partesLinha(j,1) == "small" || partesLinha(j,1) == "unacc" || partesLinha(j,1) == "2")
            baseOriginal(i,j) = 0;
        elseif (partesLinha(j,1) == "med" || partesLinha(j,1) == "3" || partesLinha(j,1) == "acc")
            baseOriginal(i,j) = 1;
         elseif (partesLinha(j,1) == "high" || partesLinha(j,1) == "big" || partesLinha(j,1) == "good" || partesLinha(j,1) == "more")   
            baseOriginal(i,j) = 2; 
         elseif (partesLinha(j,1) == "vhigh" || partesLinha(j,1) == "5more" || partesLinha(j,1) == "vgood")   
            baseOriginal(i,j) = 3;
         elseif partesLinha(j,1) == "4"
             if j == 3 
                 baseOriginal(i,j) = 2;
             else 
                 baseOriginal(i,j) = 1;
             end
        end
    end
end


% 2 - Ciclo inicial de 10 treinamentos

% Inicializar entradas e neurônios
I = 6;
H = 6;
O = 1;
matrizEntrada = baseOriginal(:,1:6)';
D = baseOriginal (:,7)';
arquivoSaida = fopen('C:\Users\oficial\Documents\DCCMAPI\Atv02\saidaT40.mat','w');
arquivoSaidaTreinos = fopen('C:\Users\oficial\Documents\DCCMAPI\Atv02\saidaTreinos40.mat','w');
fprintf(arquivoSaida,'Aprendizado da RNA\n');
fprintf(arquivoSaida,'Dados básicos do teste:\n');
fprintf(arquivoSaida,'Neuronios camada de entrada: %d\n', I);
fprintf(arquivoSaida,'Neuronios camada escondida: %d\n', H);
fprintf(arquivoSaida,'Neuronios camada de saida: %d\n', O);
fprintf(arquivoSaidaTreinos,'Aprendizado da RNA\n');
fprintf(arquivoSaidaTreinos,'Dados básicos do teste:\n');
fprintf(arquivoSaidaTreinos,'Neuronios camada de entrada: %d\n', I);
fprintf(arquivoSaidaTreinos,'Neuronios camada escondida: %d\n', H);
fprintf(arquivoSaidaTreinos,'Neuronios camada de saida: %d\n', O);
fprintf(arquivoSaidaTreinos,'Pesos entre as camadas são inicializados a cada treinamento.\n');

% Inicializar pesos
% Whi - matriz de pesos entre a camada de entrada e a camada escondida
% H - quantidade de neuronios da camada escondida
% I - quantidade de neuronios da camada de entrada
% bias_hi - bias da camada escondida - uso opcional
% Woh - matriz de pesos entre a camada escondida e a camada de saída
% bias_oh - bias da camada de saída - uso opcional
treinamento = 1;

while treinamento < 11 

Whi = rand(H,I) - 0.5; 
bias_hi = rand(H,1) - 0.5;
bias_hi = bias_hi .* 0; % zerando o bias
Woh = rand(O,H) - 0.5; 
bias_oh = rand(O,1) - 0.5;
bias_hi = bias_hi .* 0; % zerando o bias
Emax = 0.005; % Erro máximo
Eav = 5; % Erro inicial


% eta - taxa de aprendizagem. Atribuir 0.05 para o eta.
eta = randi(1000)/1000;
% constante da função linear (função de ativação). k = 1
k = 1;

fprintf(arquivoSaida,'\n\nDados básicos desse treinamento:\n');
fprintf(arquivoSaida,'Pesos aleatórios\n');
fprintf(arquivoSaida,'Pesos entre a camada de entrada e escondida:\n');
formatSpec = '%.4f \t';
fprintf(arquivoSaida,formatSpec,Whi);
fprintf(arquivoSaida,'\nPesos entre a camada escondida e de saida:\n');
fprintf(arquivoSaida,formatSpec,Woh);
fprintf(arquivoSaida,'\n');

% Fase Forward
% Calcular entrada da camada escondida
% X - matriz com valores de entrada da rede. Cada coluna se refere a
% uma caracteristica do carro e as linhas os dados de cada carro a ser 
% avaliado. 
% net_h - valores de entrada da camada escondida

amplitude = randi(25);
inicioIteracao = randi(1627);
iteracao = inicioIteracao;
fprintf(arquivoSaida,'\n\nTreinamento nº - %d\n', treinamento);
fprintf(arquivoSaida,'Treinamento será feito por %d iteracoes a partir da instancia %d da base de carros\n\n', amplitude, inicioIteracao);
fprintf(arquivoSaidaTreinos,'\n\nTreinamento nº - %d\n', treinamento);
fprintf(arquivoSaidaTreinos,'Treinamento será feito por %d iteracoes a partir da instancia %d da base de carros\n\n', amplitude, inicioIteracao);

while iteracao < (inicioIteracao+amplitude)
    Eav = 5;
    EixoDeEavs = [Eav];
    
fprintf(arquivoSaida,'Resultados após %d processamentos de dados de entrada\n', iteracao);

while Eav > Emax 
    X = matrizEntrada(1:6,iteracao+1);
    net_h = Whi .* X + bias_hi * ones(1, size(X,2));

    % Calcular a saída da camada escondida
    % Yh é a saída da camada escondida
    Yh = logsig(net_h);

    % Calcular entrada da camada de saída
    % net_o - valores de entrada da camada de saída
    net_o = Woh * Yh + bias_oh * ones(1, size(Yh,2) );

    % Calcular a saída da rede neural
    % função de ativação - linear
    Y = K * net_o;
   
    % Calcular erro de saída
    % D - vetor que abriga os valores corretos de cada entrada
    % E - Erro da rede
    E = D(1,iteracao+1) - Y;
    
    % Inicio da fase de Backward 
    % Calcular variação dos pesos entre as camadas de saída e escondida
    % delta_Woh - delta dos pesos entre a saída e camada escondida
    df = k * ones(size(net_o));
    delta_bias_oh = eta .* sum((E .* df)')';
    delta_bias_oh = 0 .* delta_bias_oh; % zerando bias
    delta_Woh = eta * (E .* df) * Yh' ;
   
    % Calcular erro retropropagado
    Eh = - Woh' * (E .* df);
   
    % Calcular variação dos pesos entre as camadas escondida e de entrada
    % df = derivada da função de ativação, no caso da sigmoide.
    % Yh = logsing(net_h)
    % delta_Whi - delta dos pesos da camada escondida e de entrada
    df = Yh - (Yh .^2);
    delta_bias_hi = -eta .* sum((Eh .* df)')';
    delta_bias_hi = 0 .* delta_bias_hi; % zerando bias
    delta_Whi = - eta * (Eh .* df) * X;

    % Calcular novos valores dos pesos
    Whi = Whi + delta_Whi;
    Woh = Woh + delta_Woh;
    bias_oh = bias_oh + delta_bias_oh;
    bias_hi = bias_hi + delta_bias_hi;

    % Calcular erro quadrático médio Eav da rede
    Eav = mse(E);
    EixoDeEavs(end+1)=Eav;

end

fprintf(arquivoSaida,'Valores Mínimos de Eav na iteracao nº %d\n', iteracao);
formatSpec = '%.4f \t';
fprintf(arquivoSaida,formatSpec,EixoDeEavs);
fprintf(arquivoSaida,'\n\n\n');
iteracao = iteracao+1;
end

% 3 - Salvar dados da execução anterior
% correlacaoM = corrcoef(Y,D);
% figure (1), clf
% imagesc(correlacaoM);
%axis image,
% set(gca,'xtick',[],'ytick',[]);
% title('Matriz de Correlação');

fprintf(arquivoSaida,'Valores finais da saída da rede ao final do treinamento\n');
formatSpec = '%.4f \t';
fprintf(arquivoSaida,formatSpec,Y);
fprintf(arquivoSaidaTreinos,'Valores finais da saída da rede ao final do treinamento\n');
fprintf(arquivoSaidaTreinos,formatSpec,Y);

treinamento = treinamento + 1; 

end

fclose(arquivoSaida);
fclose(arquivoSaidaTreinos);
