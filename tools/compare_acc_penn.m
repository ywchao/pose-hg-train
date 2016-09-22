
figure(1);

% hg-single-no-skip train
log_file = './exp/penn_action_cropped/hg-single-no-skip/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--r'); hold on;
subplot(1,2,2); plot(loss,'--r'); hold on;

% hg-single-no-skip val
log_file = './exp/penn_action_cropped/hg-single-no-skip/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'r');
subplot(1,2,2); plot(loss,'r');

% hg-single-no-skip test
log_file = './exp/penn_action_cropped/hg-single-no-skip-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'r:');
subplot(1,2,2); plot([1,100],[loss,loss],'r:');

% hg-single-no-skip-ft train
log_file = './exp/penn_action_cropped/hg-single-no-skip-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--b');
subplot(1,2,2); plot(loss,'--b');

% hg-single-no-skip-ft valid
log_file = './exp/penn_action_cropped/hg-single-no-skip-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'b');
subplot(1,2,2); plot(loss,'b');

% hg-single-no-skip-ft test
log_file = './exp/penn_action_cropped/hg-single-no-skip-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'b:');
subplot(1,2,2); plot([1,100],[loss,loss],'b:');

% hg-256-ft train
log_file = './exp/penn_action_cropped/hg-256-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--m');
subplot(1,2,2); plot(loss,'--m');

% hg-256-ft valid
log_file = './exp/penn_action_cropped/hg-256-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'m');
subplot(1,2,2); plot(loss,'m');

% hg-256-ft test
log_file = './exp/penn_action_cropped/hg-256-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'m:');
subplot(1,2,2); plot([1,100],[loss,loss],'m:');

% hg-512-ft train
log_file = './exp/penn_action_cropped/hg-512-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--c');
subplot(1,2,2); plot(loss,'--c');

% hg-512-ft valid
log_file = './exp/penn_action_cropped/hg-512-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'c');
subplot(1,2,2); plot(loss,'c');

% hg-512-ft test
log_file = './exp/penn_action_cropped/hg-512-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'c:');
subplot(1,2,2); plot([1,100],[loss,loss],'c:');

% hg-single-ft train
log_file = './exp/penn_action_cropped/hg-single-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--g');
subplot(1,2,2); plot(loss,'--g');

% hg-single-ft valid
log_file = './exp/penn_action_cropped/hg-single-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'g');
subplot(1,2,2); plot(loss,'g');

% hg-single-ft test
log_file = './exp/penn_action_cropped/hg-single-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'g:');
subplot(1,2,2); plot([1,100],[loss,loss],'g:');

% hg-256-no-skip-ft train
log_file = './exp/penn_action_cropped/hg-256-no-skip-ft/train.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'--k');
subplot(1,2,2); plot(loss,'--k');

% hg-256-no-skip-ft valid
log_file = './exp/penn_action_cropped/hg-256-no-skip-ft/valid.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot(acc,'k');
subplot(1,2,2); plot(loss,'k');

% hg-256-no-skip-ft test
log_file = './exp/penn_action_cropped/hg-256-no-skip-ft-final-preds/test.log';
f = fopen(log_file);
C = textscan(f,'%s %s %s %s');
fclose(f);
acc = cellfun(@(x)str2double(x),C{1}(2:end));
loss = cellfun(@(x)str2double(x),C{3}(2:end));
subplot(1,2,1); plot([1,100],[acc,acc],'k:');
subplot(1,2,2); plot([1,100],[loss,loss],'k:');

% set legend
subplot(1,2,1);
h_leg = legend('hg-single-no-skip scratch (train)', ...
    'hg-single-no-skip scratch (valid)', ...
    'hg-single-no-skip scratch (test)', ...
    'hg-single-no-skip fine-tune (train)', ...
    'hg-single-no-skip fine-tune (valid)', ...
    'hg-single-no-skip fine-tune (test)', ...
    'hg-256 fine-tune (train)', ...
    'hg-256 fine-tune (valid)', ...
    'hg-256 fine-tune (test)', ...
    'hg-512 fine-tune (train)', ...
    'hg-512 fine-tune (valid)', ...
    'hg-512 fine-tune (test)', ...
    'hg-single fine-tune (train)', ...
    'hg-single fine-tune (valid)', ...
    'hg-single fine-tune (test)', ...
    'hg-256-no-skip fine-tune (train)', ...
    'hg-256-no-skip fine-tune (valid)', ...
    'hg-256-no-skip fine-tune (test)', ...
    'Location', 'southeast');
set(h_leg,'FontSize',5);
subplot(1,2,2);
h_leg = legend('hg-single-no-skip scratch (train)', ...
    'hg-single-no-skip scratch (valid)', ...
    'hg-single-no-skip scratch (test)', ...
    'hg-single-no-skip fine-tune (train)', ...
    'hg-single-no-skip fine-tune (valid)', ...
    'hg-single-no-skip fine-tune (test)', ...
    'hg-256 fine-tune (train)', ...
    'hg-256 fine-tune (valid)', ...
    'hg-256 fine-tune (test)', ...
    'hg-512 fine-tune (train)', ...
    'hg-512 fine-tune (valid)', ...
    'hg-512 fine-tune (test)', ...
    'hg-single fine-tune (train)', ...
    'hg-single fine-tune (valid)', ...
    'hg-single fine-tune (test)', ...
    'hg-256-no-skip fine-tune (train)', ...
    'hg-256-no-skip fine-tune (valid)', ...
    'hg-256-no-skip fine-tune (test)', ...
    'Location', 'northeast');
set(h_leg,'FontSize',5);

% set other properties
subplot(1,2,1);
grid on;
set(gca,'fontsize',8);
xlabel('epoch');
ylabel('mean PCK');
subplot(1,2,2);
grid on;
set(gca,'fontsize',8);
xlabel('epoch');
ylabel('loss');

% save to file
save_file = 'outputs/mean_pck_penn.pdf';
if ~exist(save_file,'file')
    set(gcf,'PaperPosition',[0 0 8 3]);
    print(gcf,save_file,'-dpdf');
end

close;
