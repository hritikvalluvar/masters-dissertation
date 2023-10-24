function plotHeatmap(matrix, figName)
    % Create heatmap
    imagesc(matrix);
    colormap('jet');
    colorbar;
    str = strcat('Heatmap of ', figName); % Concatenate the strings
    title(str);
    xlabel('Column Index');
    ylabel('Row Index');