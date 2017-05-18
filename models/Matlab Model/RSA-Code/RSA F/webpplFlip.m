function [success] = webpplFlip(number)
%flip(number) I want to mimic the flip function from webppl for conceptual
%ease translating webppl to matlab (and vica versa)

the_flip = rand();

if number >= the_flip
    success = 1;
else
    success = 0;
end