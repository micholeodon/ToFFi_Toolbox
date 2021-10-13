function pairplot(meas, label, group, colors, mode)
% pairplot(mat, label, group, colors, mode)
%
% pairwise scatter & histogram different colors with group
%
% e.g.
%  % For stat toolbox users
%  load fisheriris.mat
%  colors = lines(3);
%  label = {'sepal-length', 'sepal-width', 'petal-length', 'petal-width'}
%  figure; pairplot(meas, label, species, colors, 'both');
%
%  % For all users
%  load Fisher.mat % included in zip
%  group= Fisher(:,1);
%  colors = lines(length(unique(group)));
%  pairplot(Fisher(:,2:end), {'PW', 'PL', 'SW', 'SL'}, num2cell(num2str(group)), colors, 'bar')
%
% Ryosuke Takeuchi 2016/12/22 - 2017-01-24
if nargin < 5
	mode = 'histogram';
end
if nargin == 3
	colors = lines(length(unique(group)));
end
groupName = unique(group);
ngroup = length(groupName);
for i = 1:size(meas, 2)
	for j = 1:size(meas, 2)
		subAx = subplot(size(meas, 2),size(meas, 2),sub2ind([size(meas, 2) size(meas, 2)], i, j));
		if i==1
			ylabel(label{j});
		end
		if j==size(meas, 2)
			xlabel(label{i});
		end
		hold on;
		if i==j
			bin = linspace(min(meas(:,i)), max(meas(:,i)), 20);
			for g = 1:ngroup
				switch mode
					case 'histogram'
						if exist('histogram')
							histogram(meas(strcmp(group, groupName{g}), i), bin, 'FaceColor', colors(g,:), ...
							'Normalization', 'probability');
						else
							disp('"histogram" does not exist. Use "bar" option for your matlab.')
							break;
						end
						xlim([bin(1) bin(end)])
					case 'bar'
						[counts, center] = histc(meas(strcmp(group, groupName{g}), i), bin);
						bar(bin, counts, 'BarWidth', 1, 'FaceColor', colors(g,:))
						xlim([bin(1) bin(end)]);
					case 'cdf'
						[f, x] = ecdf(meas(strcmp(group, groupName{g}), i));
						plot(x, f, 'Color', colors(g,:));
					case 'both'
						axes(subAx);
						histogram(meas(strcmp(group, groupName{g}), i), bin, 'FaceColor', colors(g,:), ...
							'Normalization', 'probability');
						xlim([bin(1) bin(end)]);
						[f, x] = ecdf(meas(strcmp(group, groupName{g}), i));

						if g ==1;
							gcaPos = subAx.Position;
							gcaPos(1:2) = gcaPos(1:2) + .75*gcaPos(3:4);
							gcaPos(3:4) = gcaPos(3:4) * .25;
							subsubAx = axes('Position', gcaPos); hold on;
						end
						axes(subsubAx);
						plot(x, f, 'Color', colors(g,:));
						axis(subsubAx, 'off', 'tight');
				end
			end
		else
			for g = 1:ngroup
				plot(meas(strcmp(group, groupName{g}), i), meas(strcmp(group, groupName{g}), j), ...
					'.', 'Color', colors(g,:));
			end
			xlim([min(meas(:, i)) max(meas(:, i))])
		end
	end
end
