# coding: utf-8
#
# Ponieważ wyliczenie modelu będzie trwać kilka do kilkunastu minut, niech każda para urochamia przykład tylko na jednym
# komputerze. Na drugim komputerze można w tym czasie pracować nad analogicznym modelem dla załączonego zbioru tweetów.
#
# Aby uruchomić ten przykład, w folderze z plikiem lda_wiki.py muszą znajdować się pliki wiki_wordids.txt.bz2 i
# ściągnięte wraz z przykładem. Przykład zbudowany w oparciu o podzbiór stron wikipedii dostępny pod adresem:
# https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles1.xml-p000000010p000010000.bz2 przekonwertowany
# na reprezentację wektorową z pomocą skryptu python -m gensim.scripts.make_wiki.

import logging, gensim

if __name__ == '__main__':
    # Włączamy logowanie, żeby śledzić postępy algorytmu
    logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

    # Odczytujemy z pliku mapowanie/słownik id->słowo
    id2word = gensim.corpora.Dictionary.load_from_text('wiki_wordids.txt.bz2')

    # Odczytujemy z pliku reprezentację wektorową korpusu (macierz wetkorów TF-IDF)
    mm = gensim.corpora.MmCorpus('wiki_tfidf.mm')
    print(mm)

    # Tworzymy model LDA z 20 grupami wykonując 20 iteracji na całym zbiorze
    lda = gensim.models.LdaMulticore(corpus=mm, id2word=id2word, num_topics=20, passes=20, workers=4)
    # Alternatywnie w razie problemów z wielowątkowością:
    # lda = gensim.models.ldamodel.LdaModel(corpus=mm, id2word=id2word, num_topics=20, update_every=0, passes=20)
    lda.print_topics(20)
