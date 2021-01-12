# coding: utf-8
#
# W parach stwórzcie model LDA w oparciu o załączone Tweety. W tym celu należy przekonwertować pliki tekstowe na
# reprezentację wektorową zapisując wcześniej mapowanie id->słowo w postaci słownika. Opis jak stworzyć wymienione
# struktury można znaleźć na stronie: https://radimrehurek.com/gensim/tut1.html.

import logging, gensim, stop_words

if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

    tweets = None   # TODO 1: Wczytaj tweety z pliku tweets.tsv
    texts = None    # TODO 2: odfiltruj słowa, usuń te z stoplisty (stop_words.get_stopwords()) oraz występujące tylko raz
    id2word = None  # TODO 3: Stwórz mapowanie/słownik id->słowo
    mm = None       # TODO 4: Stwórz reprezentację wektorową korpusu (macierz wetkorów TF-IDF)

    lda = gensim.models.ldamodel.LdaModel(corpus=mm, id2word=id2word, num_topics=10, update_every=0, passes=20)
    # alternatywnie lda =  gensim.models.LdaMulticore(corpus=mm, id2word=id2word, num_topics=10, passes=20)
    lda.print_topics(10)

    # TODO 5*: Na podstawie zbudowanego modelu określ proporcje tematów w następującym tweecie:
    # Zlatan is looking mighty attractive at the moment,if LVG doesn't get a striker by Tuesday, I really don't fancy us scoring goals this season

    # Jeśli masz czas, zwiększ wartości parametrów num_topics i  passes przy tworzeniu modelu LDA i sprawdź jak to wpłynie na rezultat