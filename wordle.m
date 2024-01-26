filters.yellows = table('Size',[0 2],'VariableTypes',["int8", "char"],'VariableNames',["Position", "Letter"]);;
filters.grays = [];
filters.greens = table('Size',[0 2],'VariableTypes',["int8", "char"],'VariableNames',["Position", "Letter"]);

freq_table = readtable('letter_frequency.xlsx');
freq = containers.Map(freq_table.Letter, freq_table.Frequency);

words = readlines('words.txt');

five_letter_words = words((strlength(words) == 5));
N = numel(five_letter_words);

words_score = table;
words_score.Word = five_letter_words;
for i = 1:N
    word_chars = convertStringsToChars(upper(words_score.Word(i)));
    words_score.Score(i) = 0;
    if true %(word_chars(1) == 'S' && ~any(ismember(word_chars, 'C')) && ~any(ismember(word_chars, 'F')) &&any(ismember(word_chars, 'R')) && ~any(ismember(word_chars, 'T')) && ~any(ismember(word_chars, 'O')) && ~any(ismember(word_chars, 'E')) && any(ismember(word_chars, 'A')) && ~any(ismember(word_chars, 'I')) && ~any(ismember(word_chars, 'N')) && ~any(ismember(word_chars, 'H')) && ~any(ismember(word_chars, 'D')))
        for j = 1:5
            ch = word_chars(j);
            if freq.isKey(ch) && find(word_chars == ch,1) == j
                words_score.Score(i) = words_score.Score(i) + freq(ch);
            end
        end
    end
end

[~,idx]=sort(words_score.Score,'descend');
sorted_words_score = words_score(idx,:);
sorted_words_score_sample = sorted_words_score(1:100,:);

function y = fits_filters(word_chars)
    y = true;
    for i = 1:size(filters.greens, 1)
        if word_chars(filters.greens.Position(i)) ~= filters.greens.Letter(i)
            y = false;
            return;
        end
    end
    for i = 1:size(filters.yellows, 1)
        if ~any(ismember(word_chars, filters.yellows.Letter(i))) || find(ismember(word_chars, filters.yellows.Letter(i))) == filters.yellows.Letter(i)
            % must be in word but not at the place already found
            y = false;
            return;
        end
    end
    for i = 1:numel(filters.grays)
        if any(ismember(word_chars, filters.grays(i)))
            y = false;
            return;
        end
    end

end