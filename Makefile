##
## EPITECH PROJECT, 2021
## Makefile
## File description:
## HASKELL
##

NAME = imageCompressor
EXEC_PATH = $(shell stack path --local-install-root)

.PHONY: all
all:	$(NAME)
$(NAME):
	stack build
	@cp $(EXEC_PATH)/bin/$(NAME) ./

.PHONY: clean
clean:
	stack clean

.PHONY: fclean
fclean: clean
	@rm -f $(NAME)

.PHONY: re
re: fclean all

#.PHONY
