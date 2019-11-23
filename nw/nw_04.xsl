<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:saxon="http://saxon.sf.net/"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- David J. Birnbaum (djbpitt@gmail.com)                      -->
    <!-- djbpitt@gmail.com, http://www.obdurodon.org                -->
    <!-- https://github.com/djbpitt/xstuff/nw .                     -->
    <!--                                                            -->
    <!-- Needleman Wunsch alignment in XSLT 3.0                     -->
    <!-- Implementation 3: Iterates over diagonals,                 -->
    <!--   uses <xsl:for-each> inside diagonal)                     -->
    <!-- Returns last cell, cumulative cells, or table in html .    -->
    <!--                                                            -->
    <!-- See:                                                       -->
    <!--   https://www.cs.sjsu.edu/~aid/cs152/NeedlemanWunsch.pdf   -->
    <!--                                                            -->
    <!-- In case of ties, arbitrarily favor diagonal, then left     -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <xsl:output method="xml" indent="yes"/>
    <xsl:key name="cellByRowCol" match="cell" use="number(@row), number(@col)" composite="yes"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- stylesheet variables .                                    -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- Darwin and Woolfe texts can be used for word alignment     -->
    <!-- darwin_1859_part and darwin_1872_part are first paragraphs -->
    <!-- darwin_1859 and darwin_1872 are entire first chapters .    -->
    <!--                                                            -->
    <!-- Full chapters don’t scale for full grid                    -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="darwin_1859_part" as="xs:string">WHEN we look to the individuals of the same
        variety or sub-variety of our older cultivated plants and animals, one of the first points
        which strikes us, is, that they generally differ much more from each other, than do the
        individuals of any one species or variety in a state of nature. When we reflect on the vast
        diversity of the plants and animals which have been cultivated, and which have varied during
        all ages under the most different climates and treatment, I think we are driven to conclude
        that this greater variability is simply due to our domestic productions having been raised
        under conditions of life not so uniform as, and somewhat different from, those to which the
        parent-species have been exposed under nature. There is, also, I think, some probability in
        the view propounded by Andrew Knight, that this variability may be partly connected with
        excess of food. It seems pretty clear that organic beings must be exposed during several
        generations to the new conditions of life to cause any appreciable amount of variation; and
        that when the organisation has once begun to vary, it generally continues to vary for many
        generations. No case is on record of a variable being ceasing to be variable under
        cultivation. Our oldest cultivated plants, such as wheat, still often yield new varieties:
        our oldest domesticated animals are still capable of rapid improvement or
        modification.</xsl:variable>
    <xsl:variable name="darwin_1872_part" as="xs:string">Causes of Variability. WHEN we compare the
        individuals of the same variety or sub-variety of our older cultivated plants and animals,
        one of the first points which strikes us is, that they generally differ more from each other
        than do the individuals of any one species or variety in a state of nature. And if we
        reflect on the vast diversity of the plants and animals which have been cultivated, and
        which have varied during all ages under the most different climates and treatment, we are
        driven to conclude that this great variability is due to our domestic productions having
        been raised under conditions of life not so uniform as, and somewhat different from, those
        to which the parent-species had been exposed under nature. There is, also, some probability
        in the view propounded by Andrew Knight, that this variability may be partly connected with
        excess of food. It seems clear that organic beings must be exposed during several
        generations to new conditions to cause any great amount of variation; and that, when the
        organisation has once begun to vary, it generally continues varying for many generations. No
        case is on record of a variable organism ceasing to vary under cultivation. Our oldest
        cultivated plants, such as wheat, still yield new varieties: our oldest domesticated animals
        are still capable of rapid improvement or modification.</xsl:variable>
    <xsl:variable name="darwin_1859" as="xs:string">WHEN we look to the individuals of the same
        variety or sub-variety of our older cultivated plants and animals, one of the first points
        which strikes us, is, that they generally differ much more from each other, than do the
        individuals of any one species or variety in a state of nature. When we reflect on the vast
        diversity of the plants and animals which have been cultivated, and which have varied during
        all ages under the most different climates and treatment, I think we are driven to conclude
        that this greater variability is simply due to our domestic productions having been raised
        under conditions of life not so uniform as, and somewhat different from, those to which the
        parent-species have been exposed under nature. There is, also, I think, some probability in
        the view propounded by Andrew Knight, that this variability may be partly connected with
        excess of food. It seems pretty clear that organic beings must be exposed during several
        generations to the new conditions of life to cause any appreciable amount of variation; and
        that when the organisation has once begun to vary, it generally continues to vary for many
        generations. No case is on record of a variable being ceasing to be variable under
        cultivation. Our oldest cultivated plants, such as wheat, still often yield new varieties:
        our oldest domesticated animals are still capable of rapid improvement or modification. It
        has been disputed at what period of life the causes of variability, whatever they may be,
        generally act; whether during the early or late period of development of the embryo, or at
        the instant of conception. Geoffroy St. Hilaire's experiments show that unnatural treatment
        of the embryo causes monstrosities; and monstrosities cannot be separated by any clear line
        of distinction from mere variations. But I am strongly inclined to suspect that the most
        frequent cause of variability may be attributed to the male and female reproductive elements
        having been affected prior to the act of conception. Several reasons make me believe in
        this; but the chief one is the remarkable effect which confinement or cultivation has on the
        functions of the reproductive system; this system appearing to be far more susceptible than
        any other part of the organisation, to the action of any change in the conditions of life.
        Nothing is more easy than to tame an animal, and few things more difficult than to get it to
        breed freely under confinement, even in the many cases when the male and female unite. How
        many animals there are which will not breed, though living long under not very close
        confinement in their native country! This is generally attributed to vitiated instincts; but
        how many cultivated plants display the utmost vigour, and yet rarely or never seed! In some
        few such cases it has been found out that very trifling changes, such as a little more or
        less water at some particular period of growth, will determine whether or not the plant sets
        a seed. I cannot here enter on the copious details which I have collected on this curious
        subject; but to show how singular the laws are which determine the reproduction of animals
        under confinement, I may just mention that carnivorous animals, even from the tropics, breed
        in this country pretty freely under confinement, with the exception of the plantigrades or
        bear family; whereas, carnivorous birds, with the rarest exceptions, hardly ever lay fertile
        eggs. Many exotic plants have pollen utterly worthless, in the same exact condition as in
        the most sterile hybrids. When, on the one hand, we see domesticated animals and plants,
        though often weak and sickly, yet breeding quite freely under confinement; and when, on the
        other hand, we see individuals, though taken young from a state of nature, perfectly tamed,
        long-lived, and healthy (of which I could give numerous instances), yet having their
        reproductive system so seriously affected by unperceived causes as to fail in acting, we
        need not be surprised at this system, when it does act under confinement, acting not quite
        regularly, and producing offspring not perfectly like their parents or variable. Habit also
        has a decided influence, as in the period of flowering with plants when transported from one
        climate to another. In animals it has a more marked effect; for instance, I find in the
        domestic duck that the bones of the wing weigh less and the bones of the leg more, in
        proportion to the whole skeleton, than do the same bones in the wild-duck; and I presume
        that this change may be safely attributed to the domestic duck flying much less, and walking
        more, than its wild parent. The great and inherited development of the udders in cows and
        goats in countries where they are habitually milked, in comparison with the state of these
        organs in other countries, is another instance of the effect of use. Not a single domestic
        animal can be named which has not in some country drooping ears; and the view suggested by
        some authors, that the drooping is due to the disuse of the muscles of the ear, from the
        animals not being much alarmed by danger, seems probable. There are many laws regulating
        variation, some few of which can be dimly seen, and will be hereafter briefly mentioned. I
        will here only allude to what may be called correlation of growth. Any change in the embryo
        or larva will almost certainly entail changes in the mature animal. In monstrosities, the
        correlations between quite distinct parts are very curious; and many instances are given in
        Isidore Geoffroy St. Hilaire's great work on this subject. Breeders believe that long limbs
        are almost always accompanied by an elongated head. Some instances of correlation are quite
        whimsical: thus cats with blue eyes are invariably deaf; colour and constitutional
        peculiarities go together, of which many remarkable cases could be given amongst animals and
        plants. From the facts collected by Heusinger, it appears that white sheep and pigs are
        differently affected from coloured individuals by certain vegetable poisons. Hairless dogs
        have imperfect teeth; long-haired and coarse-haired animals are apt to have, as is asserted,
        long or many horns; pigeons with feathered feet have skin between their outer toes; pigeons
        with short beaks have small feet, and those with long beaks large feet. Hence, if man goes
        on selecting, and thus augmenting, any peculiarity, he will almost certainly unconsciously
        modify other parts of the structure, owing to the mysterious laws of the correlation of
        growth. The result of the various, quite unknown, or dimly seen laws of variation is
        infinitely complex and diversified. It is well worth while carefully to study the several
        treatises published on some of our old cultivated plants, as on the hyacinth, potato, even
        the dahlia, &amp;c.; and it is really surprising to note the endless points in structure and
        constitution in which the varieties and sub-varieties differ slightly from each other. The
        whole organisation seems to have become plastic, and tends to depart in some small degree
        from that of the parental type. Any variation which is not inherited is unimportant for us.
        But the number and diversity of inheritable deviations of structure, both those of slight
        and those of considerable physiological importance, is endless. Dr. Prosper Lucas's
        treatise, in two large volumes, is the fullest and the best on this subject. No breeder
        doubts how strong is the tendency to inheritance: like produces like is his fundamental
        belief: doubts have been thrown on this principle by theoretical writers alone. When a
        deviation appears not unfrequently, and we see it in the father and child, we cannot tell
        whether it may not be due to the same original cause acting on both; but when amongst
        individuals, apparently exposed to the same conditions, any very rare deviation, due to some
        extraordinary combination of circumstances, appears in the parent — say, once amongst
        several million individuals — and it reappears in the child, the mere doctrine of chances
        almost compels us to attribute its reappearance to inheritance. Every one must have heard of
        cases of albinism, prickly skin, hairy bodies, &amp;c., appearing in several members of the
        same family. If strange and rare deviations of structure are truly inherited, less strange
        and commoner deviations may be freely admitted to be inheritable. Perhaps the correct way of
        viewing the whole subject, would be, to look at the inheritance of every character whatever
        as the rule, and non-inheritance as the anomaly. The laws governing inheritance are quite
        unknown; no one can say why the same peculiarity in different individuals of the same
        species, and in individuals of different species, is sometimes inherited and sometimes not
        so; why the child often reverts in certain characters to its grandfather or grandmother or
        other much more remote ancestor; why a peculiarity is often transmitted from one sex to both
        sexes, or to one sex alone, more commonly but not exclusively to the like sex. It is a fact
        of some little importance to us, that peculiarities appearing in the males of our domestic
        breeds are often transmitted either exclusively, or in a much greater degree, to males
        alone. A much more important rule, which I think may be trusted, is that, at whatever period
        of life a peculiarity first appears, it tends to appear in the offspring at a corresponding
        age, though sometimes earlier. In many cases this could not be otherwise: thus the inherited
        peculiarities in the horns of cattle could appear only in the offspring when nearly mature;
        peculiarities in the silkworm are known to appear at the corresponding caterpillar or cocoon
        stage. But hereditary diseases and some other facts make me believe that the rule has a
        wider extension, and that when there is no apparent reason why a peculiarity should appear
        at any particular age, yet that it does tend to appear in the offspring at the same period
        at which it first appeared in the parent. I believe this rule to be of the highest
        importance in explaining the laws of embryology. These remarks are of course confined to the
        first appearance of the peculiarity, and not to its primary cause, which may have acted on
        the ovules or male element; in nearly the same manner as in the crossed offspring from a
        short-horned cow by a long-horned bull, the greater length of horn, though appearing late in
        life, is clearly due to the male element. Having alluded to the subject of reversion, I may
        here refer to a statement often made by naturalists — namely, that our domestic varieties,
        when run wild, gradually but certainly revert in character to their aboriginal stocks. Hence
        it has been argued that no deductions can be drawn from domestic races to species in a state
        of nature. I have in vain endeavoured to discover on what decisive facts the above statement
        has so often and so boldly been made. There would be great difficulty in proving its truth:
        we may safely conclude that very many of the most strongly-marked domestic varieties could
        not possibly live in a wild state. In many cases we do not know what the aboriginal stock
        was, and so could not tell whether or not nearly perfect reversion had ensued. It would be
        quite necessary, in order to prevent the effects of intercrossing, that only a single
        variety should be turned loose in its new home. Nevertheless, as our varieties certainly do
        occasionally revert in some of their characters to ancestral forms, it seems to me not
        improbable, that if we could succeed in naturalising, or were to cultivate, during many
        generations, the several races, for instance, of the cabbage, in very poor soil (in which
        case, however, some effect would have to be attributed to the direct action of the poor
        soil), that they would to a large extent, or even wholly, revert to the wild aboriginal
        stock. Whether or not the experiment would succeed, is not of great importance for our line
        of argument; for by the experiment itself the conditions of life are changed. If it could be
        shown that our domestic varieties manifested a strong tendency to reversion, — that is, to
        lose their acquired characters, whilst kept under unchanged conditions, and whilst kept in a
        considerable body, so that free intercrossing might check, by blending together, any slight
        deviations of structure, in such case, I grant that we could deduce nothing from domestic
        varieties in regard to species. But there is not a shadow of evidence in favour of this
        view: to assert that we could not breed our cart and race-horses, long and short-horned
        cattle, and poultry of various breeds, and esculent vegetables, for an almost infinite
        number of generations, would be opposed to all experience. I may add, that when under nature
        the conditions of life do change, variations and reversions of character probably do occur;
        but natural selection, as will hereafter be explained, will determine how far the new
        characters thus arising shall be preserved. When we look to the hereditary varieties or
        races of our domestic animals and plants, and compare them with species closely allied
        together, we generally perceive in each domestic race, as already remarked, less uniformity
        of character than in true species. Domestic races of the same species, also, often have a
        somewhat monstrous character; by which I mean, that, although differing from each other, and
        from the other species of the same genus, in several trifling respects, they often differ in
        an extreme degree in some one part, both when compared one with another, and more especially
        when compared with all the species in nature to which they are nearest allied. With these
        exceptions (and with that of the perfect fertility of varieties when crossed, — a subject
        hereafter to be discussed), domestic races of the same species differ from each other in the
        same manner as, only in most cases in a lesser degree than, do closely-allied species of the
        same genus in a state of nature. I think this must be admitted, when we find that there are
        hardly any domestic races, either amongst animals or plants, which have not been ranked by
        some competent judges as mere varieties, and by other competent judges as the descendants of
        aboriginally distinct species. If any marked distinction existed between domestic races and
        species, this source of doubt could not so perpetually recur. It has often been stated that
        domestic races do not differ from each other in characters of generic value. I think it
        could be shown that this statement is hardly correct; but naturalists differ most widely in
        determining what characters are of generic value; all such valuations being at present
        empirical. Moreover, on the view of the origin of genera which I shall presently give, we
        have no right to expect often to meet with generic differences in our domesticated
        productions. When we attempt to estimate the amount of structural difference between the
        domestic races of the same species, we are soon involved in doubt, from not knowing whether
        they have descended from one or several parent-species. This point, if it could be cleared
        up, would be interesting; if, for instance, it could be shown that the grey- hound,
        bloodhound, terrier, spaniel, and bull-dog, which we all know propagate their kind so truly,
        were the offspring of any single species, then such facts would have great weight in making
        us doubt about the immutability of the many very closely allied and natural species — for
        instance, of the many foxes — inhabiting different quarters of the world. I do not believe,
        as we shall presently see, that all our dogs have descended from any one wild species; but,
        in the case of some other domestic races, there is presumptive, or even strong, evidence in
        favour of this view. It has often been assumed that man has chosen for domestication animals
        and plants having an extraordinary inherent tendency to vary, and likewise to withstand
        diverse climates. I do not dispute that these capacities have added largely to the value of
        most of our domesticated productions; but how could a savage possibly know, when he first
        tamed an animal, whether it would vary in succeeding generations, and whether it would
        endure other climates? Has the little variability of the ass or guinea-fowl, or the small
        power of endurance of warmth by the rein-deer, or of cold by the common camel, prevented
        their domestication? I cannot doubt that if other animals and plants, equal in number to our
        domesticated productions, and belonging to equally diverse classes and countries, were taken
        from a state of nature, and could be made to breed for an equal number of generations under
        domestication, they would vary on an average as largely as the parent species of our
        existing domesticated productions have varied. In the case of most of our anciently
        domesticated animals and plants, I do not think it is possible to come to any definite
        conclusion, whether they have descended from one or several species. The argument mainly
        relied on by those who believe in the multiple origin of our domestic animals is, that we
        find in the most ancient records, more especially on the monuments of Egypt, much diversity
        in the breeds; and that some of the breeds closely resemble, perhaps are identical with,
        those still existing. Even if this latter fact were found more strictly and generally true
        than seems to me to be the case, what does it show, but that some of our breeds originated
        there, four or five thousand years ago? But Mr. Horner's researches have rendered it in some
        degree probable that man sufficiently civilized to have manufactured pottery existed in the
        valley of the Nile thirteen or fourteen thousand years ago; and who will pretend to say how
        long before these ancient periods, savages, like those of Tierra del Fuego or Australia, who
        possess a semi-domestic dog, may not have existed in Egypt? The whole subject must, I think,
        remain vague; neverthelsss, I may, without here entering on any details, state that, from
        geographical and other considerations, I think it highly probable that our domestic dogs
        have descended from several wild species. In regard to sheep and goats I can form no
        opinion. I should think, from facts communicated to me by Mr. Blyth, on the habits, voice,
        and constitution, &amp;c., of the humped Indian cattle, that these had descended from a
        different aboriginal stock from our European cattle; and several competent judges believe
        that these latter have had more than one wild parent. With respect to horses, from reasons
        which I cannot give here, I am doubtfully inclined to believe, in opposition to several
        authors, that all the races have descended from one wild stock. Mr. Blyth, whose opinion,
        from his large and varied stores of knowledge, I should value more than that of almost any
        one, thinks that all the breeds of poultry have proceeded from the common wild Indian fowl
        (Gallus bankiva). In regard to ducks and rabbits, the breeds of which differ considerably
        from each other in structure, I do not doubt that they all have descended from the common
        wild duck and rabbit. The doctrine of the origin of our several domestic races from several
        aboriginal stocks, has been carried to an absurd extreme by some authors. They believe that
        every race which breeds true, let the distinctive characters be ever so slight, has had its
        wild prototype. At this rate there must have existed at least a score of species of wild
        cattle, as many sheep, and several goats in Europe alone, and several even within Great
        Britain. One author believes that there formerly existed in Great Britain eleven wild
        species of sheep peculiar to it! When we bear in mind that Britain has now hardly one
        peculiar mammal, and France but few distinct from those of Germany and conversely, and so
        with Hungary, Spain, &amp;c., but that each of these kingdoms possesses several peculiar
        breeds of cattle, sheep, &amp;c., we must admit that many domestic breeds have originated in
        Europe; for whence could they have been derived, as these several countries do not possess a
        number of peculiar species as distinct parent-stocks? So it is in India. Even in the case of
        the domestic dogs of the whole world, which I fully admit have probably descended from
        several wild species, I cannot doubt that there has been an immense amount of inherited
        variation. Who can believe that animals closely resembling the Italian greyhound, the
        bloodhound, the bull-dog, or Blenheim spaniel, &amp;;c. — so unlike all wild Canidæ — ever
        existed freely in a state of nature? It has often been loosely said that all our races of
        dogs have been produced by the crossing of a few aboriginal species; but by crossing we can
        get only forms in some degree intermediate between their parents; and if we account for our
        several domestic races by this process, we must admit the former existence of the most
        extreme forms, as the Italian greyhound, bloodhound, bull-dog, &amp;c., in the wild state.
        Moreover, the possibility of making distinct races by crossing has been greatly exaggerated.
        There can be no doubt that a race may be modified by occasional crosses, if aided by the
        careful selection of those individual mongrels, which present any desired character; but
        that a race could be obtained nearly intermediate between two extremely different races or
        speceies, I can hardly believe. Sir J. Sebright expressly experimentised for this object,
        and failed. The offspring from the first cross between two pure breeds is tolerably and
        sometimes (as I have found with pigeons) extremely uniform, and everything seems simple
        enough; but when these mongrels are crossed one with another for several generations, hardly
        two of them will be alike, and then the extreme difficulty, or rather utter hopelessness, of
        the task becomes apparent. Certainly, a breed intermediate between two very distinct breeds
        could not be got without extreme care and long-continued selection; nor can I find a single
        case on record of a permanent race having been thus formed. On the Breeds of the Domestic
        Pigeon .— Believing that it is always best to study some special group, I have, after
        deliberation, taken up domestic pigeons. I have kept every breed which I could purchase or
        obtain, and have been most kindly favoured with skins from several quarters of the world,
        more especially by the Hon. W. Elliot from India, and by the Hon. C. Murray from Persia.
        Many treatises in different languages have been published on pigeons, and some of them are
        very important, as being of considerable antiquity. I have associated with several eminent
        fanciers, and have been permitted to join two of the London Pigeon Clubs. The diversity of
        the breeds is something astonishing. Compare the English carrier and the short-faced
        tumbler, and see the wonderful difference in their beaks, entailing corresponding
        differences in their skulls. The carrier, more especially the male bird, is also remarkable
        from the wonderful development of the carunculated skin about the head, and this is
        accompanied by greatly elongated eyelids, very large external orifices to the nostrils, and
        a wide gape of mouth. The short-faced tumbler has a beak in outline almost like that of a
        finch; and the common tumbler has the singular and strictly inherited habit of flying at a
        great height in a compact flock, and tumbling in the air head over heels. The runt is a bird
        of great size, with long, massive beak and large feet; some of the sub-breeds of runts have
        very long necks, others very long wings and tails, others singularly short tails. The barb
        is allied to the carrier, but, instead of a very long beak, has a very short and very broad
        one. The pouter has a much elongated body, wings, and legs; and its enormously developed
        crop, which it glories in inflating, may well excite astonishment and even laughter. The
        turbit has a very short and conical beak, with a line of reversed feathers down the breast;
        and it has the habit of continually expanding slightly the upper part of the œsophagus. The
        Jacobin has the feathers so much reversed along the back of the neck that they form a hood,
        and it has, proportionally to its size, much elongated wing and tail feathers. The trumpeter
        and laugher, as their names express, utter a very different coo from the other breeds. The
        fantail has thirty or even forty tail-feathers, instead of twelve or fourteen, the normal
        number in all members of the great pigeon family; and these feathers are kept expanded, and
        are carried so erect that in good birds the head and tail touch; the oil-gland is quite
        aborted. Several other less distinct breeds might have been specified. In the skeletons of
        the several breeds, the development of the bones of the face in length and breadth and
        curvature differs enormously. The shape, as well as the breadth and length of the ramus of
        the lower jaw, varies in a highly remarkable manner. The number of the caudal and sacral
        vertebræ vary; as does the number of the ribs, together with their relative breadth and the
        presence of processes. The size and shape of the apertures in the sternum are highly
        variable; so is the degree of divergence and relative size of the two arms of the furcula.
        The proportional width of the gape of mouth, the proportional length of the eyelids, of the
        orifice of the nostrils, of the tongue (not always in strict correlation with the length of
        beak), the size of the crop and of the upper part of the œsophagus; the development and
        abortion of the oil-gland; the number of the primary wing and caudal feathers; the relative
        length of wing and tail to each other and to the body; the relative length of leg and of the
        feet; the number of scutellæ on the toes, the development of skin between the toes, are all
        points of structure which are variable. The period at which the perfect plumage is acquired
        varies, as does the state of the down with which the nestling birds are clothed when
        hatched. The shape and size of the eggs vary. The manner of flight differs remarkably; as
        does in some breeds the voice and disposition. Lastly, in certain breeds, the males and
        females have come to differ to a slight degree from each other. Altogether at least a score
        of pigeons might be chosen, which if shown to an ornithologist, and he were told that they
        were wild birds, would certainly, I think, be ranked by him as well-defined species.
        Moreover, I do not believe that any ornithologist would place the English carrier, the
        short-faced tumbler, the runt, the barb, pouter, and fantail in the same genus; more
        especially as in each of these breeds several truly-inherited sub-breeds, or species as he
        might have called them, could be shown him. Great as the differences are between the breeds
        of pigeons, I am fully convinced that the common opinion of naturalists is correct, namely,
        that all have descended from the rock-pigeon (Columba livia), including under this term
        several geographical races or sub-species, which differ from each other in the most trifling
        respects. As several of the reasons which have led me to this belief are in some degree
        applicable in other cases, I will here briefly give them. If the several breeds are not
        varieties, and have not proceeded from the rock-pigeon, they must have descended from at
        least seven or eight aboriginal stocks; for it is impossible to make the present domestic
        breeds by the crossing of any lesser number: how, for instance, could a pouter be produced
        by crossing two breeds unless one of the parent-stocks possessed the characteristic enormous
        crop? The supposed aboriginal stocks must all have been rock-pigeons, that is, not breeding
        or willingly perching on trees. But besides C. livia, with its geographical sub-species,
        only two or three other species of rock-pigeons are known; and these have not any of the
        characters of the domestic breeds. Hence the supposed aboriginal stocks must either still
        exist in the countries where they were originally domesticated, and yet be unknown to
        ornithologists; and this, considering their size, habits, and remarkable characters, seems
        very improbable; or they must have become extinct in the wild state. But birds breeding on
        precipices, and good fliers, are unlikely to be exterminated; and the common rock-pigeon,
        which has the same habits with the domestic breeds, has not been exterminated even on
        several of the smaller British islets, or on the shores of the Mediterranean. Hence the
        supposed extermination of so many species having similar habits with the rock-pigeon seems
        to me a very rash assumption. Moreover, the several above-named domesticated breeds have
        been transported to all parts of the world, and, therefore, some of them must have been
        carried back again into their native country; but not one has ever become wild or feral,
        though the dovecot-pigeon, which is the rock-pigeon in a very slightly altered state, has
        become feral in several places. Again, all recent experience shows that it is most difficult
        to get any wild animal to breed freely under domestication; yet on the hypothesis of the
        multiple origin of our pigeons, it must be assumed that at least seven or eight species were
        so thoroughly domesticated in ancient times by half-civilized man, as to be quite prolific
        under confinement. An argument, as it seems to me, of great weight, and applicable in
        several other cases, is, that the above-specified breeds, though agreeing generally in
        constitution, habits, voice, colouring, and in most parts of their structure, with the wild
        rock-pigeon, yet are certainly highly abnormal in other parts of their structure: we may
        look in vain throughout the whole great family of Columbidæ for a beak like that of the
        English carrier, or that of the short-faced tumbler, or barb; for reversed feathers like
        those of the jacobin; for a crop like that of the pouter; for tail-feathers like those of
        the fantail. Hence it must be assumed not only that half-civilized man succeeded in
        thoroughly domesticating several species, but that he intentionally or by chance picked out
        extraordinarily abnormal species; and further, that these very species have since all become
        extinct or unknown. So many strange contingencies seem to me improbable in the highest
        degree. Some facts in regard to the colouring of pigeons well deserve consideration. The
        rock-pigeon is of a slaty-blue, and has a white rump (the Indian sub-species, C. intermedia
        of Strickland, having it bluish); the tail has a terminal dark bar, with the bases of the
        outer feathers externally edged with white; the wings have two black bars; some
        semi-domestic breeds and some apparently truly wild breeds have, besides the two black bars,
        the wings chequered with black. These several marks do not occur together in any other
        species of the whole family. Now, in every one of the domestic breeds, taking thoroughly
        well-bred birds, all the above marks, even to the white edging of the outer tail-feathers,
        sometimes concur perfectly developed. Moreover, when two birds belonging to two distinct
        breeds are crossed, neither of which is blue or has any of the above-specified marks, the
        mongrel offspring are very apt suddenly to acquire these characters; for instance, I crossed
        some uniformly white fantails with some uniformly black barbs, and they produced mottled
        brown and black birds; these I again crossed together, and one grandchild of the pure white
        fantail and pure black barb was of as beautiful a blue colour, with the white rump, double
        black wing-bar, and barred and white-edged tail-feathers, as any wild rock-pigeon! We can
        understand these facts, on the well-known principle of reversion to ancestral characters, if
        all the domestic breeds have descended from the rock-pigeon. But if we deny this, we must
        make one of the two following highly improbable suppositions. Either, firstly, that all the
        several imagined aboriginal stocks were coloured and marked like the rock-pigeon, although
        no other existing species is thus coloured and marked, so that in each separate breed there
        might be a tendency to revert to the very same colours and markings. Or, secondly, that each
        breed, even the purest, has within a dozen or, at most, within a score of generations, been
        crossed by the rock-pigeon: I say within a dozen or twenty generations, for we know of no
        fact countenancing the belief that the child ever reverts to some one ancestor, removed by a
        greater number of generations. In a breed which has been crossed only once with some
        distinct breed, the tendency to reversion to any character derived from such cross will
        naturally become less and less, as in each succeeding generation there will be less of the
        foreign blood; but when there has been no cross with a distinct breed, and there is a
        tendency in both parents to revert to a character, which has been lost during some former
        generation, this tendency, for all that we can see to the contrary, may be transmitted
        undiminished for an indefinite number of generations. These two distinct cases are often
        confounded in treatises on inheritance. Lastly, the hybrids or mongrels from between all the
        domestic breeds of pigeons are perfectly fertile. I can state this from my own observations,
        purposely made on the most distinct breeds. Now, it is difficult, perhaps impossible, to
        bring forward one case of the hybrid offspring of two animals clearly distinct being
        themselves perfectly fertile. Some authors believe that long-continued domestication
        eliminates this strong tendency to sterility: from the history of the dog I think there is
        some probability in this hypothesis, if applied to species closely related together, though
        it is unsupported by a single experiment. But to extend the hypothesis so far as to suppose
        that species, aboriginally as distinct as carriers, tumblers, pouters, and fantails now are,
        should yield offspring perfectly fertile, inter se , seems to me rash in the extreme. From
        these several reasons, namely, the improbability of man having formerly got seven or eight
        supposed species of pigeons to breed freely under domestication; these supposed species
        being quite unknown in a wild state, and their becoming nowhere feral; these species having
        very abnormal characters in certain respects, as compared with all other Columbidæ, though
        so like in most other respects to the rock-pigeon; the blue colour and various marks
        occasionally appearing in all the breeds, both when kept pure and when crossed; the mongrel
        offspring being perfectly fertile; — from these several reasons, taken together, I can feel
        no doubt that all our domestic breeds have descended from the Columba livia with its
        geographical sub-species. In favour of this view, I may add, firstly, that C. livia, or the
        rock-pigeon, has been found capable of domestication in Europe and in India; and that it
        agrees in habits and in a great number of points of structure with all the domestic breeds.
        Secondly, although an English carrier or short-faced tumbler differs immensely in certain
        characters from the rock-pigeon, yet by comparing the several sub-breeds of these breeds,
        more especially those brought from distant countries, we can make an almost perfect series
        between the extremes of structure. Thirdly, those characters which are mainly distinctive of
        each breed, for instance the wattle and length of beak of the carrier, the shortness of that
        of the tumbler, and the number of tail-feathers in the fantail, are in each breed eminently
        variable; and the explanation of this fact will be obvious when we come to treat of
        selection. Fourthly, pigeons have been watched, and tended with the utmost care, and loved
        by many people. They have been domesticated for thousands of years in several quarters of
        the world; the earliest known record of pigeons is in the fifth ægyptian dynasty, about 3000
        B.C., as was pointed out to me by Professor Lepsius; but Mr. Birch informs me that pigeons
        are given in a bill of fare in the previous dynasty. In the time of the Romans, as we hear
        from Pliny, immense prices were given for pigeons; \"nay, they are come to this pass, that
        they can reckon up their pedigree and race.\" Pigeons were much valued by Akber Khan in
        India, about the year 1600; never less than 20,000 pigeons were taken with the court. \"The
        monarchs of Iran and Turan sent him some very rare birds;\" and, continues the courtly
        historian, \"His Majesty by crossing the breeds, which method was never practised before,
        has improved them astonishingly.\" About this same period the Dutch were as eager about
        pigeons as were the old Romans. The paramount importance of these considerations in
        explaining the immense amount of variation which pigeons have undergone, will be obvious
        when we treat of Selection. We shall then, also, see how it is that the breeds so often have
        a somewhat monstrous character. It is also a most favourable circumstance for the production
        of distinct breeds, that male and female pigeons can be easily mated for life; and thus
        different breeds can be kept together in the same aviary. I have discussed the probable
        origin of domestic pigeons at some, yet quite insufficient, length; because when I first
        kept pigeons and watched the several kinds, knowing well how true they bred, I felt fully as
        much difficulty in believing that they could ever have descended from a common parent, as
        any naturalist could in coming to a similar conclusion in regard to the many species of
        finches, or other large groups of birds, in nature. One circumstance has struck me much;
        namely, that all the breeders of the various domestic animals and the cultivators of plants,
        with whom I have ever conversed, or whose treatises I have read, are firmly convinced that
        the several breeds to which each has attended, are descended from so many aboriginally
        distinct species. Ask, as I have asked, a celebrated raiser of Hereford cattle, whether his
        cattle might not have descended from long-horns, and he will laugh you to scorn. I have
        never met a pigeon, or poultry, or duck, or rabbit fancier, who was not fully convinced that
        each main breed was descended from a distinct species. Van Mons, in his treatise on pears
        and apples, shows how utterly he disbelieves that the several sorts, for instance a
        Ribston-pippin or Codlin-apple, could ever have proceeded from the seeds of the same tree.
        Innumerable other examples could be given. The explanation, I think, is simple: from
        long-continued study they are strongly impressed with the differences between the several
        races; and though they well know that each race varies slightly, for they win their prizes
        by selecting such slight differences, yet they ignore all general arguments, and refuse to
        sum up in their minds slight differences accumulated during many successive generations. May
        not those naturalists who, knowing far less of the laws of inheritance than does the
        breeder, and knowing no more than he does of the intermediate links in the long lines of
        descent, yet admit that many of our domestic races have descended from the same parents —
        may they not learn a lesson of caution, when they deride the idea of species in a state of
        nature being lineal descendants of other species? Selection . — Let us now briefly consider
        the steps by which domestic races have been produced, either from one or from several allied
        species. Some little effect may, perhaps, be attributed to the direct action of the external
        conditions of life, and some little to habit; but he would be a bold man who would account
        by such agencies for the differences of a dray and race horse, a greyhound and bloodhound, a
        carrier and tumbler pigeon. One of the most remarkable features in our domesticated races is
        that we see in them adaptation, not indeed to the animal's or plant's own good, but to man's
        use or fancy. Some variations useful to him have probably arisen suddenly, or by one step;
        many botanists, for instance, believe that the fuller's teazle, with its hooks, which cannot
        be rivalled by any mechanical contrivance, is only a variety of the wild Dipsacus; and this
        amount of change may have suddenly arisen in a seedling. So it has probably been with the
        turnspit dog; and this is known to have been the case with the ancon sheep. But when we
        compare the dray-horse and race-horse, the dromedary and camel, the various breeds of sheep
        fitted either for cultivated land or mountain pasture, with the wool of one breed good for
        one purpose, and that of another breed for another purpose; when we compare the many breeds
        of dogs, each good for man in very different ways; when we compare the game-cock, so
        pertinacious in battle, with other breeds so little quarrelsome, with \"everlasting layers\"
        which never desire to sit, and with the bantam so small and elegant; when we compare the
        host of agricultural, culinary, orchard, and flower-garden races of plants, most useful to
        man at different seasons and for different purposes, or so beautiful in his eyes, we must, I
        think, look further than to mere variability. We cannot suppose that all the breeds were
        suddenly produced as perfect and as useful as we now see them; indeed, in several cases, we
        know that this has not been their history. The key is man's power of accumulative selection:
        nature gives successive variations; man adds them up in certain directions useful to him. In
        this sense he may be said to make for himself useful breeds. The great power of this
        principle of selection is not hypothetical. It is certain that several of our eminent
        breeders have, even within a single lifetime, modified to a large extent some breeds of
        cattle and sheep. In order fully to realise what they have done, it is almost necessary to
        read several of the many treatises devoted to this subject, and to inspect the animals.
        Breeders habitually speak of an animal's organisation as something quite plastic, which they
        can model almost as they please. If I had space I could quote numerous passages to this
        effect from highly competent authorities. Youatt, who was probably better acquainted with
        the works of agriculturalists than almost any other individual, and who was himself a very
        good judge of an animal, speaks of the principle of selection as \"that which enables the
        agriculturist, not only to modify the character of his flock, but to change it altogether.
        It is the magician's wand, by means of which he may summon into life whatever form and mould
        he pleases.\" Lord Somerville, speaking of what breeders have done for sheep, says: — \"It
        would seem as if they had chalked out upon a wall a form perfect in itself, and then had
        given it existence.\" That most skilful breeder, Sir John Sebright, used to say, with
        respect to pigeons, that \"he would produce any given feather in three years, but it would
        take him six years to obtain head and beak.\" In Saxony the importance of the principle of
        selection in regard to merino sheep is so fully recognised, that men follow it as a trade:
        the sheep are placed on a table and are studied, like a picture by a connoisseur; this is
        done three times at intervals of months, and the sheep are each time marked and classed, so
        that the very best may ultimately be selected for breeding. What English breeders have
        actually effected is proved by the enormous prices given for animals with a good pedigree;
        and these have now been exported to almost every quarter of the world. The improvement is by
        no means generally due to crossing different breeds; all the best breeders are strongly
        opposed to this practice, except sometimes amongst closely allied sub-breeds. And when a
        cross has been made, the closest selection is far more indispensable even than in ordinary
        cases. If selection consisted merely in separating some very distinct variety, and breeding
        from it, the principle would be so obvious as hardly to be worth notice; but its importance
        consists in the great effect produced by the accumulation in one direction, during
        successive generations, of differences absolutely inappreciable by an uneducated eye —
        differences which I for one have vainly attempted to appreciate. Not one man in a thousand
        has accuracy of eye and judgment sufficient to become an eminent breeder. If gifted with
        these qualities, and he studies his subject for years, and devotes his lifetime to it with
        indomitable perseverance, he will succeed, and may make great improvements; if he wants any
        of these qualities, he will assuredly fail. Few would readily believe in the natural
        capacity and years of practice requisite to become even a skilful pigeon-fancier. The same
        principles are followed by horticulturists; but the variations are here often more abrupt.
        No one supposes that our choicest productions have been produced by a single variation from
        the aboriginal stock. We have proofs that this is not so in some cases, in which exact
        records have been kept; thus, to give a very trifling instance, the steadily-increasing size
        of the common gooseberry may be quoted. We see an astonishing improvement in many florists'
        flowers, when the flowers of the present day are compared with drawings made only twenty or
        thirty years ago. When a race of plants is once pretty well established, the seed-raisers do
        not pick out the best plants, but merely go over their seed-beds, and pull up the
        \"rogues,\" as they call the plants that deviate from the proper standard. With animals this
        kind of selection is, in fact, also followed; for hardly any one is so careless as to allow
        his worst animals to breed. In regard to plants, there is another means of observing the
        accumulated effects of selection — namely, by comparing the diversity of flowers in the
        different varieties of the same species in the flower-garden; the diversity of leaves, pods,
        or tubers, or whatever part is valued, in the kitchen-garden, in comparison with the flowers
        of the same varieties; and the diversity of fruit of the same species in the orchard, in
        comparison with the leaves and flowers of the same set of varieties. See how different the
        leaves of the cabbage are, and how extremely alike the flowers; how unlike the flowers of
        the heartsease are, and how alike the leaves; how much the fruit of the different kinds of
        gooseberries differ in size, colour, shape, and hairiness, and yet the flowers present very
        slight differences. It is not that the varieties which differ largely in some one point do
        not differ at all in other points; this is hardly ever, perhaps never, the case. The laws of
        correlation of growth, the importance of which should never be overlooked, will ensure some
        differences; but, as a general rule, I cannot doubt that the continued selection of slight
        variations, either in the leaves, the flowers, or the fruit, will produce races differing
        from each other chiefly in these characters. It may be objected that the principle of
        selection has been reduced to methodical practice for scarcely more than three-quarters of a
        century; it has certainly been more attended to of late years, and many treatises have been
        published on the subject; and the result, I may add, has been, in a corresponding degree,
        rapid and important. But it is very far from true that the principle is a modern discovery.
        I could give several references to the full acknowledgment of the importance of the
        principle in works of high antiquity. In rude and barbarous periods of English history
        choice animals were often imported, and laws were passed to prevent their exportation: the
        destruction of horses under a certain size was ordered, and this may be compared to the
        \"roguing\" of plants by nurserymen. The principle of selection I find distinctly given in
        an ancient Chinese encyclopædia. Explicit rules are laid down by some of the Roman classical
        writers. From passages in Genesis, it is clear that the colour of domestic animals was at
        that early period attended to. Savages now sometimes cross their dogs with wild canine
        animals, to improve the breed, and they formerly did so, as is attested by passages in
        Pliny. The savages in South Africa match their draught cattle by colour, as do some of the
        Esquimaux their teams of dogs. Livingstone shows how much good domestic breeds are valued by
        the negroes of the interior of Africa who have not associated with Europeans. Some of these
        facts do not show actual selection, but they show that the breeding of domestic animals was
        carefully attended to in ancient times, and is now attended to by the lowest savages. It
        would, indeed, have been a strange fact, had attention not been paid to breeding, for the
        inheritance of good and bad qualities is so obvious. At the present time, eminent breeders
        try by methodical selection, with a distinct object in view, to make a new strain or
        sub-breed, superior to anything existing in the country. But, for our purpose, a kind of
        Selection, which may be called Unconscious, and which results from every one trying to
        possess and breed from the best individual animals, is more important. Thus, a man who
        intends keeping pointers naturally tries to get as good dogs as he can, and afterwards
        breeds from his own best dogs, but he has no wish or expectation of permanently altering the
        breed. Nevertheless I cannot doubt that this process, continued during centuries, would
        improve and modify any breed, in the same way as Bakewell, Collins, &amp;c., by this very
        same process, only carried on more methodically, did greatly modify, even during their own
        lifetimes, the forms and qualities of their cattle. Slow and insensible changes of this kind
        could never be recognised unless actual measurements or careful drawings of the breeds in
        question had been made long ago, which might serve for comparison. In some cases, however,
        unchanged or but little changed individuals of the same breed may be found in less civilised
        districts, where the breed has been less improved. There is reason to believe that King
        Charles's spaniel has been unconsciously modified to a large extent since the time of that
        monarch. Some highly competent authorities are convinced that the setter is directly derived
        from the spaniel, and has probably been slowly altered from it. It is known that the English
        pointer has been greatly changed within the last century, and in this case the change has,
        it is believed, been chiefly effected by crosses with the fox-hound; but what concerns us
        is, that the change has been effected unconsciously and gradually, and yet so effectually,
        that, though the old Spanish pointer certainly came from Spain, Mr. Borrow has not seen, as
        I am informed by him, any native dog in Spain like our pointer. By a similar process of
        selection, and by careful training, the whole body of English racehorses have come to
        surpass in fleetness and size the parent Arab stock, so that the latter, by the regulations
        for the Goodwood Races, are favoured in the weights they carry. Lord Spencer and others have
        shown how the cattle of England have increased in weight and in early maturity, compared
        with the stock formerly kept in this country. By comparing the accounts given in old pigeon
        treatises of carriers and tumblers with these breeds as now existing in Britain, India, and
        Persia, we can, I think, clearly trace the stages through which they have insensibly passed,
        and come to differ so greatly from the rock-pigeon. Youatt gives an excellent illustration
        of the effects of a course of selection, which may be considered as unconsciously followed,
        in so far that the breeders could never have expected or even have wished to have produced
        the result which ensued — namely, the production of two distinct strains. The two flocks of
        Leicester sheep kept by Mr. Buckley and Mr. Burgess, as Mr. Youatt remarks, \"have been
        purely bred from the original stock of Mr. Bakewell for upwards of fifty years. There is not
        a suspicion existing in the mind of any one at all acquainted with the subject that the
        owner of either of them has deviated in any one instance from the pure blood of Mr.
        Bakewell's flock, and yet the difference between the sheep possessed by these two gentlemen
        is so great that they have the appearance of being quite different varieties.\" If there
        exist savages so barbarous as never to think of the inherited character of the offspring of
        their domestic animals, yet any one animal particularly useful to them, for any special
        purpose, would be carefully preserved during famines and other accidents, to which savages
        are so liable, and such choice animals would thus generally leave more offspring than the
        inferior ones; so that in this case there would be a kind of unconscious selection going on.
        We see the value set on animals even by the barbarians of Tierra del Fuego, by their killing
        and devouring their old women, in times of dearth, as of less value than their dogs. In
        plants the same gradual process of improvement, through the occasional preservation of the
        best individuals, whether or not sufficiently distinct to be ranked at their first
        appearance as distinct varieties, and whether or not two or more species or races have
        become blended together by crossing, may plainly be recognised in the increased size and
        beauty which we now see in the varieties of the heartsease, rose, pelargonium, dahlia, and
        other plants, when compared with the older varieties or with their parent-stocks. No one
        would ever expect to get a first-rate heartsease or dahlia from the seed of a wild plant. No
        one would expect to raise a first-rate melting pear from the seed of the wild pear, though
        he might succeed from a poor seedling growing wild, if it had come from a garden-stock. The
        pear, though cultivated in classical times, appears, from Pliny's description, to have been
        a fruit of very inferior quality. I have seen great surprise expressed in horticultural
        works at the wonderful skill of gardeners, in having produced such splendid results from
        such poor materials; but the art, I cannot doubt, has been simple, and, as far as the final
        result is concerned, has been followed almost unconsciously. It has consisted in always
        cultivating the best known variety, sowing its seeds, and, when a slightly better variety
        has chanced to appear, selecting it, and so onwards. But the gardeners of the classical
        period, who cultivated the best pear they could procure, never thought what splendid fruit
        we should eat; though we owe our excellent fruit, in some small degree, to their having
        naturally chosen and preserved the best varieties they could anywhere find. A large amount
        of change in our cultivated plants, thus slowly and unconsciously accumulated, explains, as
        I believe, the well-known fact, that in a vast number of cases we cannot recognise, and
        therefore do not know, the wild parent-stocks of the plants which have been longest
        cultivated in our flower and kitchen gardens. If it has taken centuries or thousands of
        years to improve or modify most of our plants up to their present standard of usefulness to
        man, we can understand how it is that neither Australia, the Cape of Good Hope, nor any
        other region inhabited by quite uncivilised man, has afforded us a single plant worth
        culture. It is not that these countries, so rich in species, do not by a strange chance
        possess the aboriginal stocks of any useful plants, but that the native plants have not been
        improved by continued selection up to a standard of perfection comparable with that given to
        the plants in countries anciently civilised. In regard to the domestic animals kept by
        uncivilised man, it should not be overlooked that they almost always have to struggle for
        their own food, at least during certain seasons. And in two countries very differently
        circumstanced, individuals of the same species, having slightly different constitutions or
        structure, would often succeed better in the one country than in the other, and thus by a
        process of \"natural selection,\" as will hereafter be more fully explained, two sub-breeds
        might be formed. This, perhaps, partly explains what has been remarked by some authors,
        namely, that the varieties kept by savages have more of the character of species than the
        varieties kept in civilised countries. On the view here given of the all-important part
        which selection by man has played, it becomes at once obvious, how it is that our domestic
        races show adaptation in their structure or in their habits to man's wants or fancies. We
        can, I think, further understand the frequently abnormal character of our domestic races,
        and likewise their differences being so great in external characters and relatively so
        slight in internal parts or organs. Man can hardly select, or only with much difficulty, any
        deviation of structure excepting such as is externally visible; and indeed he rarely cares
        for what is internal. He can never act by selection, excepting on variations which are first
        given to him in some slight degree by nature. No man would ever try to make a fantail, till
        he saw a pigeon with a tail developed in some slight degree in an unusual manner, or a
        pouter till he saw a pigeon with a crop of somewhat unusual size; and the more abnormal or
        unusual any character was when it first appeared, the more likely it would be to catch his
        attention. But to use such an expression as trying to make a fantail, is, I have no doubt,
        in most cases, utterly incorrect. The man who first selected a pigeon with a slightly larger
        tail, never dreamed what the descendants of that pigeon would become through long-continued,
        partly unconscious and partly methodical selection. Perhaps the parent bird of all fantails
        had only fourteen tail-feathers somewhat expanded, like the present Java fantail, or like
        individuals of other and distinct breeds, in which as many as seventeen tail-feathers have
        been counted. Perhaps the first pouter-pigeon did not inflate its crop much more than the
        turbit now does the upper part of its œsophagus, — a habit which is disregarded by all
        fanciers, as it is not one of the points of the breed. Nor let it be thought that some great
        deviation of structure would be necessary to catch the fancier's eye: he perceives extremely
        small differences, and it is in human nature to value any novelty, however slight, in one's
        own possession. Nor must the value which would formerly be set on any slight differences in
        the individuals of the same species, be judged of by the value which would now be set on
        them, after several breeds have once fairly been established. Many slight differences might,
        and indeed do now, arise amongst pigeons, which are rejected as faults or deviations from
        the standard of perfection of each breed. The common goose has not given rise to any marked
        varieties; hence the Thoulouse and the common breed, which differ only in colour, that most
        fleeting of characters, have lately been exhibited as distinct at our poultry-shows. I think
        these views further explain what has sometimes been noticed — namely that we know nothing
        about the origin or history of any of our domestic breeds. But, in fact, a breed, like a
        dialect of a language, can hardly be said to have had a definite origin. A man preserves and
        breeds from an individual with some slight deviation of structure, or takes more care than
        usual in matching his best animals and thus improves them, and the improved individuals
        slowly spread in the immediate neighbourhood. But as yet they will hardly have a distinct
        name, and from being only slightly valued, their history will be disregarded. When further
        improved by the same slow and gradual process, they will spread more widely, and will get
        recognised as something distinct and valuable, and will then probably first receive a
        provincial name. In semi-civilised countries, with little free communication, the spreading
        and knowledge of any new sub-breed will be a slow process. As soon as the points of value of
        the new sub-breed are once fully acknowledged, the principle, as I have called it, of
        unconscious selection will always tend, — perhaps more at one period than at another, as the
        breed rises or falls in fashion, — perhaps more in one district than in another, according
        to the state of civilisation of the inhabitants, — slowly to add to the characteristic
        features of the breed, whatever they may be. But the chance will be infinitely small of any
        record having been preserved of such slow, varying, and insensible changes. I must now say a
        few words on the circumstances, favourable, or the reverse, to man's power of selection. A
        high degree of variability is obviously favourable, as freely giving the materials for
        selection to work on; not that mere individual differences are not amply sufficient, with
        extreme care, to allow of the accumulation of a large amount of modification in almost any
        desired direction. But as variations manifestly useful or pleasing to man appear only
        occasionally, the chance of their appearance will be much increased by a large number of
        individuals being kept; and hence this comes to be of the highest importance to success. On
        this principle Marshall has remarked, with respect to the sheep of parts of Yorkshire, that
        \"as they generally belong to poor people, and are mostly in small lots , they never can be
        improved.\" On the other hand, nurserymen, from raising large stocks of the same plants, are
        generally far more successful than amateurs in getting new and valuable varieties. The
        keeping of a large number of individuals of a species in any country requires that the
        species should be placed under favourable conditions of life, so as to breed freely in that
        country. When the individuals of any species are scanty, all the individuals, whatever their
        quality may be, will generally be allowed to breed, and this will effectually prevent
        selection. But probably the most important point of all, is, that the animal or plant should
        be so highly useful to man, or so much valued by him, that the closest attention should be
        paid to even the slightest deviation in the qualities or structure of each individual.
        Unless such attention be paid nothing can be effected. I have seen it gravely remarked, that
        it was most fortunate that the strawberry began to vary just when gardeners began to attend
        closely to this plant. No doubt the strawberry had always varied since it was cultivated,
        but the slight varieties had been neglected. As soon, however, as gardeners picked out
        individual plants with slightly larger, earlier, or better fruit, and raised seedlings from
        them, and again picked out the best seedlings and bred from them, then, there appeared
        (aided by some crossing with distinct species) those many admirable varieties of the
        strawberry which have been raised during the last thirty or forty years. In the case of
        animals with separate sexes, facility in preventing crosses is an important element of
        success in the formation of new races, — at least, in a country which is already stocked
        with other races. In this respect enclosure of the land plays a part. Wandering savages or
        the inhabitants of open plains rarely possess more than one breed of the same species.
        Pigeons can be mated for life, and this is a great convenience to the fancier, for thus many
        races may be kept true, though mingled in the same aviary; and this circumstance must have
        largely favoured the improvement and formation of new breeds. Pigeons, I may add, can be
        propagated in great numbers and at a very quick rate, and inferior birds may be freely
        rejected, as when killed they serve for food. On the other hand, cats, from their nocturnal
        rambling habits, cannot be matched, and, although so much valued by women and children, we
        hardly ever see a distinct breed kept up; such breeds as we do sometimes see are almost
        always imported from some other country, often from islands. Although I do not doubt that
        some domestic animals vary less than others, yet the rarity or absence of distinct breeds of
        the cat, the donkey, peacock, goose, &amp;c., may be attributed in main part to selection
        not having been brought into play: in cats, from the difficulty in pairing them; in donkeys,
        from only a few being kept by poor people, and little attention paid to their breeding; in
        peacocks, from not being very easily reared and a large stock not kept; in geese, from being
        valuable only for two purposes, food and feathers, and more especially from no pleasure
        having been felt in the display of distinct breeds. To sum up on the origin of our Domestic
        Races of animals and plants. I believe that the conditions of life, from their action on the
        reproductive system, are so far of the highest importance as causing variability. I do not
        believe that variability is an inherent and necessary contingency, under all circumstances,
        with all organic beings, as some authors have thought. The effects of variability are
        modified by various degrees of inheritance and of reversion. Variability is governed by many
        unknown laws, more especially by that of correlation of growth. Something may be attributed
        to the direct action of the conditions of life. Something must be attributed to use and
        disuse. The final result is thus rendered infinitely complex. In some cases, I do not doubt
        that the intercrossing of species, aboriginally distinct, has played an important part in
        the origin of our domestic productions. When in any country several domestic breeds have
        once been established, their occasional intercrossing, with the aid of selection, has, no
        doubt, largely aided in the formation of new sub-breeds; but the importance of the crossing
        of varieties has, I believe, been greatly exaggerated, both in regard to animals and to
        those plants which are propagated by seed. In plants which are temporarily propagated by
        cuttings, buds, &amp;c., the importance of the crossing both of distinct species and of
        varieties is immense; for the cultivator here quite disregards the extreme variability both
        of hybrids and mongrels, and the frequent sterility of hybrids; but the cases of plants not
        propagated by seed are of little importance to us, for their endurance is only temporary.
        Over all these causes of Change I am convinced that the accumulative action of Selection,
        whether applied methodically and more quickly, or unconsciously and more slowly, but more
        efficiently, is by far the predominant Power. </xsl:variable>
    <xsl:variable name="darwin_1872" as="xs:string">Causes of Variability. WHEN we compare the
        individuals of the same variety or sub-variety of our older cultivated plants and animals,
        one of the first points which strikes us is, that they generally differ more from each other
        than do the individuals of any one species or variety in a state of nature. And if we
        reflect on the vast diversity of the plants and animals which have been cultivated, and
        which have varied during all ages under the most different climates and treatment, we are
        driven to conclude that this great variability is due to our domestic productions having
        been raised under conditions of life not so uniform as, and somewhat different from, those
        to which the parent-species had been exposed under nature. There is, also, some probability
        in the view propounded by Andrew Knight, that this variability may be partly connected with
        excess of food. It seems clear that organic beings must be exposed during several
        generations to new conditions to cause any great amount of variation; and that, when the
        organisation has once begun to vary, it generally continues varying for many generations. No
        case is on record of a variable organism ceasing to vary under cultivation. Our oldest
        cultivated plants, such as wheat, still yield new varieties: our oldest domesticated animals
        are still capable of rapid improvement or modification. As far as I am able to judge, after
        long attending to the subject, the conditions of life appear to act in two ways, — directly
        on the whole organisation or on certain parts alone, and in directly by affecting the
        reproductive system. With respect to the direct action, we must bear in mind that in every
        case, as Professor Weismann has lately insisted, and as I have incidentally shown in my work
        on 'Variation under Domestication,' there are two factors: namely, the nature of the
        organism, and the nature of the conditions. The former seems to be much the more important;
        for nearly similar variations sometimes arise under, as far as we can judge, dissimilar
        conditions; and, on the other hand, dissimilar variations arise under conditions which
        appear to be nearly uniform. The effects on the offspring are either definite or in
        definite. They may be considered as definite when all or nearly all the offspring of
        individuals exposed to certain conditions during several generations are modified in the
        same manner. It is extremely difficult to come to any conclusion in regard to the extent of
        the changes which have been thus definitely induced. There can, however, be little doubt
        about many slight changes, — such as size from the amount of food, colour from the nature of
        the food, thickness of the skin and hair from climate, &amp;C. Each of the endless
        variations which we see in the plumage of our fowls must have had some efficient cause; and
        if the same cause were to act uniformly during a long series of generations on many
        individuals, all probably would be modified in the same manner. Such facts as the complex
        and extraordinary out-growths which invariably follow from the insertion of a minute drop of
        poison by a gall-producing insect, show us what singular modifications might result in the
        case of plants from a chemical change in the nature of the sap. Indefinite variability is a
        much more common result of changed conditions than definite variability, and has probably
        played a more important part in the formation of our domestic races. We see indefinite
        variability in the endless slight peculiarities which distinguish the individuals of the
        same species, and which cannot be accounted for by inheritance from either parent or from
        some more remote ancestor. Even strongly-marked differences occasionally appear in the young
        of the same litter, and in seedlings from the same seed-capsule. At long intervals of time,
        out of millions of individuals reared in the same country and fed on nearly the same food,
        deviations of structure so strongly pronounced as to deserve to be called monstrosities
        arise; but monstrosities cannot be separated by any distinct line from slighter variations.
        All such changes of structure, whether extremely slight or strongly marked, which appear
        amongst many individuals living together, may be considered as the indefinite effects of the
        conditions of life on each individual organism, in nearly the same manner as a chill affects
        different men in an indefinite manner, according to their state of body or constitution,
        causing coughs or colds, rheumatism, or inflammations of various organs. With respect to
        what I have called the in direct action of changed conditions, namely, through the
        reproductive system being affected, we may infer that variability is thus induced, partly
        from the fact of this system being extremely sensitive to any change in the conditions, and
        partly from the similarity, as Kölreuter and others have remarked, between the variability
        which follows from the crossing of distinct species, and that which may be observed with
        plants and animals when reared under new or unnatural conditions. Many facts clearly show
        how eminently susceptible the reproductive system is to very slight changes in the
        surrounding conditions. Nothing is more easy than to tame an animal, and few things more
        difficult than to get it to breed freely under confinement, even when the male and female
        unite. How many animals there are which will not breed, though kept in an almost free state
        in their native country! This is generally, but erroneously, attributed to vitiated
        instincts. Many cultivated plants display the utmost vigour, and yet rarely or never seed!
        In some few cases it has been discovered that a very trifling change, such as a little more
        or less water at some particular period of growth, will determine whether or not a plant
        will produce seeds. I cannot here give the details which I have collected and elsewhere
        published on this curious subject; but to show how singular the laws are which determine the
        reproduction of animals under confinement, I may mention that carnivorous animals, even from
        the tropics, breed in this country pretty freely under confinement, with the exception of
        the plantigrades or bear family, which seldom produce young; whereas carnivorous birds, with
        the rarest exceptions, hardly ever lay fertile eggs. Many exotic plants have pollen utterly
        worthless, in the same condition as in the most sterile hybrids. When, on the one hand, we
        see domesticated animals and plants, though often weak and sickly, breeding freely under
        confinement; and when, on the other hand, we see individuals, though taken young from a
        state of nature perfectly tamed, long-lived and healthy (of which I could give numerous
        instances), yet having their reproductive system so seriously affected by unperceived causes
        as to fail to act, we need not be surprised at this system, when it does act under
        confinement, acting irregularly, and producing offspring somewhat unlike their parents. I
        may add, that as some organisms breed freely under the most unnatural conditions (for
        instance, rabbits and ferrets kept in hutches), showing that their reproductive organs are
        not easily affected; so will some animals and plants withstand domestication or cultivation,
        and vary very slightly — perhaps hardly more than in a state of nature. Some naturalists
        have maintained that all variations are connected with the act of sexual reproduction; but
        this is certainly an error; for I have given in another work a long list of \"sporting
        plants;\" as they are called by gardeners; — that is, of plants which have suddenly produced
        a single bud with a new and sometimes widely different character from that of the other buds
        on the same plant. These bud variations, as they may be named, can be propagated by grafts,
        offsets, &amp;c., and sometimes by seed. They occur rarely under nature, but are far from
        rare under culture. As a single bud out of many thousands, produced year after year on the
        same tree under uniform conditions, has been known suddenly to assume a new character; and
        as buds on distinct trees, growing under different conditions, have sometimes yielded nearly
        the same variety — for instance, buds on peach-trees producing nectarines, and buds on
        common roses producing moss-roses — we clearly see that the nature of the conditions is of
        subordinate importance in comparison with the nature of the organism in determining each
        particular form of variation; — perhaps of not more importance than the nature of the spark,
        by which a mass of combustible matter is ignited, has in determining the nature of the
        flames. Effects of Habit and of the Use or Disuse of Parts; Correlated Variation;
        Inheritance. Changed habits produce an inherited effect, as in the period of the flowering
        of plants when transported from one climate to another. With animals the increased use or
        disuse of parts has had a more marked influence; thus I find in the domestic duck that the
        bones of the wing weigh less and the bones of the leg more, in proportion to the whole
        skeleton, than do the same bones in the wild duck; and this change may be safely attributed
        to the domestic duck flying much less, and walking more, than its wild parents. The great
        and inherited development of the udders in cows and goats in countries where they are
        habitually milked, in comparison with these organs in other countries, is probably another
        instance of the effects of use. Not one of our domestic animals can be named which has not
        in some country drooping ears; and the view which has been suggested that the drooping is
        due to the disuse of the muscles of the ear, from the animals being seldom much alarmed,
        seems probable. Many laws regulate variation, some few of which can be dimly seen, and will
        hereafter be briefly discussed. I will here only allude to what may be called correlated
        variation. Important changes in the embryo or larva will probably entail changes in the
        mature animal. In monstrosities, the correlations between quite distinct parts are very
        curious; and many instances are given in Isidore Geoffroy St. Hilaire's great work on this
        subject. Breeders believe that long limbs are almost always accompanied by an elongated
        head. Some instances of correlation are quite whimsical; thus cats which are entirely white
        and have blue eyes are generally deaf; but it has been lately stated by Mr. Tait that this
        is confined to the males. Colour and constitutional peculiarities go together, of which many
        remarkable cases could be given amongst animals and plants. From facts collected by
        Heusinger, it appears that white sheep and pigs are injured by certain plants, whilst
        dark-coloured individuals escape: Professor Wyman has recently communicated to me a good
        illustration of this fact; on asking some farmers in Virginia how it was that all their pigs
        were black, they informed him that the pigs ate the paint-root (Lachnanthes), which coloured
        their bones pink, and which caused the hoofs of all but the black varieties to drop off; and
        one of the \"crackers\" ( i.e. Virginia squatters) added, \"we select the black members of a
        litter for raising, as they alone have a good chance of living.\" Hairless dogs have
        imperfect teeth: long-haired and coarse-haired animals are apt to have, as is asserted, long
        or many horns; pigeons with feathered feet have skin between their outer toes; pigeons with
        short beaks have small feet, and those with long beaks large feet. Hence if man goes on
        selecting, and thus augmenting, any peculiarity, he will almost certainly modify
        unintentionally other parts of the structure, owing to the mysterious laws of correlation.
        The results of the various, unknown, or but dimly understood laws of variation are
        infinitely complex and diversified. It is well worth while carefully to study the several
        treatises on some of our old cultivated plants, as on the hyacinth, potato, even the dahlia,
        &amp;c.; and it is really surprising to note the endless points of structure and
        constitution in which the varieties and sub-varieties differ slightly from each other. The
        whole organisation seems to have become plastic, and departs in a slight degree from that of
        the parental type. Any variation which is not inherited is unimportant for us. But the
        number and diversity of inheritable deviations of structure, both those of slight and those
        of considerable physiological importance, are endless. Dr. Prosper Lucas's treatise, in two
        large volumes, is the fullest and the best on this subject. No breeder doubts how strong is
        the tendency to inheritance; that like produces like is his fundamental belief: doubts have
        been thrown on this principle only by theoretical writers. When any deviation of structure
        often appears, and we see it in the father and child, we cannot tell whether it may not be
        due to the same cause having acted on both; but when amongst individuals, apparently exposed
        to the same conditions, any very rare deviation, due to some extraordinary combination of
        circumstances, appears in the parent — say, once among several million individuals — and it
        reappears in the child, the mere doctrine of chances almost compels us to attribute its
        reappearance to inheritance. Every one must have heard of cases of albinism, prickly skin,
        hairy bodies, &amp;c., appearing in several members of the same family. If strange and rare
        deviations of structure are really inherited, less strange and commoner deviations may be
        freely admitted to be inheritable. Perhaps the correct way of viewing the whole subject
        would be, to look at the inheritance of every character whatever as the rule, and
        non-inheritance as the anomaly. The laws governing inheritance are for the most part
        unknown. No one can say why the same peculiarity in different individuals of the same
        species, or in different species, is sometimes inherited and sometimes not so; why the child
        often reverts in certain characteristics to its grandfather or grandmother or more remote
        ancestor; why a peculiarity is often transmitted from one sex to both sexes, or to one sex
        alone, more commonly but not exclusively to the like sex. It is a fact of some importance to
        us, that peculiarities appearing in the males of our domestic breeds are often transmitted,
        either exclusively or in a much greater degree, to the males alone. A much more important
        rule, which I think may be trusted, is that, at whatever period of life a peculiarity first
        appears, it tends to re-appear in the offspring at a corresponding age, though sometimes
        earlier. In many cases this could not be otherwise; thus the inherited peculiarities in the
        horns of cattle could appear only in the offspring when nearly mature; peculiarities in the
        silk-worm are known to appear at the corresponding caterpillar or cocoon stage. But
        hereditary diseases and some other facts make me believe that the rule has a wider
        extension, and that, when there is no apparent reason why a peculiarity should appear at any
        particular age, yet that it does tend to appear in the offspring at the same period at which
        it first appeared in the parent. I believe this rule to be of the highest importance in
        explaining the laws of embryology. These remarks are of course confined to the first
        appearance of the peculiarity, and not to the primary cause which may have acted on the
        ovules or on the male element; in nearly the same manner as the increased length of the
        horns in the offspring from a short-horned cow by a long-horned bull, though appearing late
        in life, is clearly due to the male element. Having alluded to the subject of reversion, I
        may here refer to a statement often made by naturalists — namely, that our domestic
        varieties, when run wild, gradually but invariably revert in character to their aboriginal
        stocks. Hence it has been argued that no deductions can be drawn from domestic races to
        species in a state of nature. I have in vain endeavoured to discover on what decisive facts
        the above statement has so often and so boldly been made. There would be great difficulty in
        proving its truth: we may safely conclude that very many of the most strongly marked
        domestic varieties could not possibly live in a wild state. In many cases we do not know
        what the aboriginal stock was, and so could not tell whether or not nearly perfect reversion
        had ensued. It would be necessary in order to prevent the effects of intercrossing, that
        only a single variety should have been turned loose in its new home. Nevertheless, as our
        varieties certainly do occasionally revert in some of their characters to ancestral forms,
        it seems to me not improbable that if we could succeed in naturalising, or were to
        cultivate, during many generations, the several races, for instance, of the cabbage, in very
        poor soil (in which case, however, some effect would have to be attributed to the definite
        action of the poor soil), that they would, to a large extent, or even wholly, revert to the
        wild aboriginal stock. Whether or not the experiment would succeed, is not of great
        importance for our line of argument; for by the experiment itself the conditions of life are
        changed. If it could be shown that our domestic varieties manifested a strong tendency to
        reversion, — that is, to lose their acquired characters, whilst kept under the same
        conditions, and whilst kept in a considerable body, so that free intercrossing might check,
        by blending together, any slight deviations in their structure, in such case, I grant that
        we could deduce nothing from domestic varieties in regard to species. But there is not a
        shadow of evidence in favour of this view: to assert that we could not breed our cart and
        race-horses, long and short-horned cattle, and poultry of various breeds, and esculent
        vegetables, for an unlimited number of generations, would be opposed to all experience.
        Character of Domestic Varieties: difficulty of distinguishing between Varieties and Species;
        origin of Domestic Varieties from one or more Species. When we look to the hereditary
        varieties or races of our domestic animals and plants, and compare them with closely allied
        species, we generally perceive in each domestic race, as already remarked, less uniformity
        of character than in true species. Domestic races often have a somewhat monstrous character;
        by which I mean, that, although differing from each other, and from other species of the
        same genus, in several trifling respects, they often differ in an extreme degree in some one
        part, both when compared one with another, and more especially when compared with the
        species under nature to which they are nearest allied. With these exceptions (and with that
        of the perfect fertility of varieties when crossed, — a subject hereafter to be discussed),
        domestic races of the same species differ from each other in the same manner as do the
        closely allied species of the same genus in a state of nature, but the differences in most
        cases are less in degree. This must be admitted as true, for the domestic races of many
        animals and plants have been ranked by some competent judges as the descendants of
        aboriginally distinct species, and by other competent judges as mere varieties. If any well
        marked distinction existed between a domestic race and a species, this source of doubt would
        not so perpetually recur. It has often been stated that domestic races do not differ from
        each other in characters of generic value. It can be shown that this statement is not
        correct; but naturalists differ much in determining what characters are of generic value;
        all such valuations being at present empirical. When it is explained how genera originate
        under nature, it will be seen that we have no right to expect often to find a generic amount
        of difference in our domesticated races. In attempting to estimate the amount of structural
        difference between allied domestic races, we are soon involved in doubt, from not knowing
        whether they are descended from one or several parent species. This point, if it could be
        cleared up, would be interesting; if, for instance, it could be shown that the greyhound,
        bloodhound, terrier, spaniel, and bull-dog, which we all know propagate their kind truly,
        were the offspring of any single species, then such facts would have great weight in making
        us doubt about the immutability of the many closely allied natural species — for instance,
        of the many foxes — inhabiting different quarters of the world. I do not believe, as we
        shall presently see, that the whole amount of difference between the several breeds of the
        dog has been produced under domestication; I believe that a small part of the difference is
        due to their being descended from distinct species. In the case of strongly marked races of
        some other domesticated species, there is presumptive or even strong evidence, that all are
        descended from a single wild stock. It has often been assumed that man has chosen for
        domestication animals and plants having an extraordinary inherent tendency to vary, and
        likewise to withstand diverse climates. I do not dispute that these capacities have added
        largely to the value of most of our domesticated productions; but how could a savage
        possibly know, when he first tamed an animal, whether it would vary in succeeding
        generations, and whether it would endure other climates? Has the little variability of the
        ass and goose, or the small power of endurance of warmth by the reindeer, or of cold by the
        common camel, prevented their domestication? I cannot doubt that if other animals and
        plants, equal in number to our domesticated productions, and belonging to equally diverse
        classes and countries, were taken from a state of nature, and could be made to breed for an
        equal number of generations under domestication, they would on an average vary as largely as
        the parent species of our existing domesticated productions have varied. In the case of most
        of our anciently domesticated animals and plants, it is not possible to come to any definite
        conclusion, whether they are descended from one or several wild species. The argument mainly
        relied on by those who believe in the multiple origin of our domestic animals is, that we
        find in the most ancient times, on the monuments of Egypt, and in the lake-habitations of
        Switzerland, much diversity in the breeds; and that some of these ancient breeds closely
        resemble, or are even identical with, those still existing. But this only throws far
        backwards the history of civilisation, and shows that animals were domesticated at a much
        earlier period than has hitherto been supposed. The lake-inhabitants of Switzerland
        cultivated several kinds of wheat and barley, the pea, the poppy for oil, and flax; and they
        possessed several domesticated animals. They also carried on commerce with other nations.
        All this clearly shows, as Heer has remarked, that they had at this early age progressed
        considerably in civilisation; and this again implies a long continued previous period of
        less advanced civilisation, during which the domesticated animals, kept by different tribes
        in different districts, might have varied and given rise to distinct races. Since the
        discovery of flint tools in the superficial formations of many parts of the world, all
        geologists believe that barbarian man existed at an enormously remote period; and we know
        that at the present day there is hardly a tribe so barbarous, as not to have domesticated at
        least the dog. The origin of most of our domestic animals will probably for ever remain
        vague. But I may here state, that, looking to the domestic dogs of the whole world, I have,
        after a laborious collection of all known facts, come to the conclusion that several wild
        species of Canidæ have been tamed, and that their blood, in some cases mingled together,
        flows in the veins of our domestic breeds. In regard to sheep and goats I can form no
        decided opinion. From facts communicated to me by Mr. Blyth, on the habits, voice,
        constitution, and structure of the humped Indian cattle, it is almost certain that they are
        descended from a different aboriginal stock from our European cattle; and some competent
        judges believe that these latter have had two or three wild progenitors, — whether or not
        these deserve to be called species. This conclusion, as well as that of the specific
        distinction between the humped and common cattle, may, indeed, be looked upon as established
        by the admirable researches of Professor Rütimeyer. With respect to horses, from reasons
        which I cannot here give, I am doubtfully inclined to believe, in opposition to several
        authors, that all the races belong to the same species. Having kept nearly all the English
        breeds of the fowl alive, having bred and crossed them, and examined their skeletons, it
        appears to me almost certain that all are the descendants of the wild Indian fowl, Gallus
        bankiva; and this is the conclusion of Mr. Blyth, and of others who have studied this bird
        in India. In regard to ducks and rabbits, some breeds of which differ much from each other,
        the evidence is clear that they are all descended from the common wild duck and rabbit. The
        doctrine of the origin of our several domestic races from several aboriginal stocks, has
        been carried to an absurd extreme by some authors. They believe that every race which breeds
        true, let the distinctive characters be ever so slight, has had its wild prototype. At this
        rate there must have existed at least a score of species of wild cattle, as many sheep, and
        several goats, in Europe alone, and several even within Great Britain. One author believes
        that there formerly existed eleven wild species of sheep peculiar to Great Britain! When we
        bear in mind that Britain has now not one peculiar mammal, and France but few distinct from
        those of Germany, and so with Hungary, Spain, &amp;c., but that each of these kingdoms
        possesses several peculiar breeds of cattle, sheep, &amp;c., we must admit that many
        domestic breeds must have originated in Europe; for whence otherwise could they have been
        derived? So it is in India. Even in the case of the breeds of the domestic dog throughout
        the world, which I admit are descended from several wild species, it cannot be doubted that
        there has been an immense amount of inherited variation; for who will believe that animals
        closely resembling the Italian greyhound, the bloodhound, the bull-dog, pug-dog, or Blenheim
        spaniel, &amp;c. — so unlike all wild Canidæ — ever existed in a state of nature? It has
        often been loosely said that all our races of dogs have been produced by the crossing of a
        few aboriginal species; but by crossing we can only get forms in some degree intermediate
        between their parents; and if we account for our several domestic races by this process, we
        must admit the former existence of the most extreme forms, as the Italian greyhound,
        bloodhound, bull-dog, &amp;c., in the wild state. Moreover, the possibility of making
        distinct races by crossing has been greatly exaggerated. Many cases are on record, showing
        that a race may be modified by occasional crosses, if aided by the careful selection of the
        individuals which present the desired character; but to obtain a race intermediate between
        two quite distinct races, would be very difficult. Sir J. Sebright expressly experimented
        with this object, and failed. The offspring from the first cross between two pure breeds is
        tolerably and sometimes (as I have found with pigeons) quite uniform in character, and
        everything seems simple enough; but when these mongrels are crossed one with another for
        several generations, hardly two of them are alike, and then the difficulty of the task
        becomes manifeSt. Breeds of the Domestic Pigeon , their Differences and Origin . Believing
        that it is always best to study some special group, I have, after deliberation, taken up
        domestic pigeons. I have kept every breed which I could purchase or obtain, and have been
        most kindly favoured with skins from several quarters of the world, more especially by the
        Hon. W. Elliott from India, and by the Hon. C. Murray from Persia. Many treatises in
        different languages have been published on pigeons, and some of them are very important, as
        being of considerable antiquity. I have associated with several eminent fanciers, and have
        been permitted to join two of the London Pigeon Clubs. The diversity of the breeds is
        something astonishing. Compare the English carrier and the short-faced tumbler, and see the
        wonderful difference in their beaks, entailing corresponding differences in their skulls.
        The carrier, more especially the male bird, is also remarkable from the wonderful
        development of the carunculated skin about the head; and this is accompanied by greatly
        elongated eyelids, very large external orifices to the nostrils, and a wide gape of mouth.
        The short-faced tumbler has a beak in outline almost like that of a finch; and the common
        tumbler has the singular inherited habit of flying at a great height in a compact flock, and
        tumbling in the air head over heels. The runt is a bird of great size, with long massive
        beak and large feet; some of the sub-breeds of runts have very long necks, others very long
        wings and tails, others singularly short tails. The barb is allied to the carrier, but,
        instead of a long beak, has a very short and broad one. The pouter has a much elongated
        body, wings, and legs; and its enormously developed crop, which it glories in inflating, may
        well excite astonishment and even laughter. The turbit has a short and conical beak, with a
        line of reversed feathers down the breast; and it has the habit of continually expanding,
        slightly, the upper part of the œsophagus. The Jacobin has the feathers so much reversed
        along the back of the neck that they form a hood; and it has, proportionally to its size,
        elongated wing and tail feathers. The trumpeter and laugher, as their names express, utter a
        very different coo from the other breeds. The fantail has thirty or even forty
        tail-feathers, instead of twelve or fourteen — the normal number in all the members of the
        great pigeon family: these feathers are kept expanded, and are carried so erect, that in
        good birds the head and tail touch: the oil-gland is quite aborted. Several other less
        distinct breeds might be specified. In the skeletons of the several breeds, the development
        of the bones of the face in length and breadth and curvature differs enormously. The shape,
        as well as the breadth and length of the ramus of the lower jaw, varies in a highly
        remarkable manner. The caudal and sacral vertebræ vary in number; as does the number of the
        ribs, together with their relative breadth and the presence of processes. The size and shape
        of the apertures in the sternum are highly variable; so is the degree of divergence and
        relative size of the two arms of the furcula. The proportional width of the gape of mouth,
        the proportional length of the eyelids, of the orifice of the nostrils, of the tongue (not
        always in strict correlation with the length of beak), the size of the crop and of the upper
        part of the œsophagus; the development and abortion of the oil-gland; the number of the
        primary wing and caudal feathers; the relative length of the wing and tail to each other and
        to the body; the relative length of the leg and foot; the number of scutellæ on the toes,
        the development of skin between the toes, are all points of structure which are variable.
        The period at which the perfect plumage is acquired varies, as does the state of the down
        with which the nestling birds are clothed when hatched. The shape and size of the eggs vary.
        The manner of flight, and in some breeds the voice and disposition, differ remarkably.
        Lastly, in certain breeds, the males and females have come to differ in a slight degree from
        each other. Altogether at least a score of pigeons might be chosen, which, if shown to an
        ornithologist, and he were told that they were wild birds, would certainly be ranked by him
        as well-defined species. Moreover, I do not believe that any ornithologist would in this
        case place the English carrier, the short-faced tumbler, the runt, the barb, pouter, and
        fantail in the same genus; more especially as in each of these breeds several
        truly-inherited sub-breeds, or species, as he would call them, could be shown him. Great as
        are the differences between the breeds of the pigeon, I am fully convinced that the common
        opinion of naturalists is correct, namely, that all are descended from the rock pigeon
        (Columba livia), including under this term several geographical races or sub-species, which
        differ from each other in the most trifling respects. As several of the reasons which have
        led me to this belief are in some degree applicable in other cases, I will here briefly give
        them. If the several breeds are not varieties, and have not proceeded from the rock-pigeon,
        they must have descended from at least seven or eight aboriginal stocks; for it is
        impossible to make the present domestic breeds by the crossing of any lesser number: how,
        for instance, could a pouter be produced by crossing two breeds unless one of the
        parent-stocks possessed the characteristic enormous crop? The supposed aboriginal stocks
        must all have been rock-pigeons, that is, they did not breed or willingly perch on trees.
        But besides C. livia, with its geographical sub-species, only two or three other species of
        rock-pigeons are known; and these have not any of the characters of the domestic breeds.
        Hence the supposed aboriginal stocks must either still exist in the countries where they
        were originally domesticated, and yet be unknown to ornithologists; and this, considering
        their size, habits, and remarkable characters, seems improbable; or they must have become
        extinct in the wild state. But birds breeding on precipices, and good fliers, are unlikely
        to be exterminated; and the common rock-pigeon, which has the same habits with the domestic
        breeds, has not been exterminated even on several of the smaller British islets, or on the
        shores of the Mediterranean. Hence the supposed extermination of so many species having
        similar habits with the rock-pigeon seems a very rash assumption. Moreover, the several
        above-named domesticated breeds have been transported to all parts of the world, and,
        therefore, some of them must have been carried back again into their native country; but not
        one has become wild or feral, though the dovecot-pigeon, which is the rock-pigeon in a very
        slightly altered state, has become feral in several places. Again, all recent experience
        shows that it is difficult to get wild animals to breed freely under domestication; yet, on
        the hypothesis of the multiple origin of our pigeons, it must be assumed that at least seven
        or eight species were so thoroughly domesticated in ancient times by half-civilised man, as
        to be quite prolific under confinement. An argument of great weight, and applicable in
        several other cases, is, that the above-specified breeds, though agreeing generally with the
        wild rock-pigeon in constitution, habits, voice, colouring, and in most parts of their
        structure, yet are certainly highly abnormal in other parts; we may look in vain through the
        whole great family of Columbidæ for a beak like that of the English carrier, or that of the
        short-faced tumbler, or barb; for reversed feathers like those of the Jacobin; for a crop
        like that of the pouter; for tail-feathers like those of the fantail. Hence it must be
        assumed not only that half-civilised man succeeded in thoroughly domesticating several
        species, but that he intentionally or by chance picked out extraordinarily abnormal species;
        and further, that these very species have since all become extinct or unknown. So many
        strange contingencies are improbable in the highest degree. Some facts in regard to the
        colouring of pigeons well deserve consideration. The rock pigeon is of a slaty-blue, with
        white loins; but the Indian sub-species, C. intermedia of Strickland, has this part bluish.
        The tail has a terminal dark bar, with the outer feathers externally edged at the base with
        white. The wings have two black bars. Some semi-domestic breeds, and some truly wild breeds,
        have, besides the two black bars, the wings chequered with black. These several marks do not
        occur together in any other species of the whole family. Now, in every one of the domestic
        breeds, taking thoroughly well-bred birds, all the above marks, even to the white edging of
        the outer tail-feathers, sometimes concur perfectly developed. Moreover, when birds
        belonging to two or more distinct breeds are crossed, none of which are blue or have any of
        the above-specified marks, the mongrel offspring are very apt suddenly to acquire these
        characters. To give one instance out of several which I have observed: — I crossed some
        white fantails, which breed very true, with some black barbs — and it so happens that blue
        varieties of barbs are so rare that I never heard of an instance in England; and the
        mongrels were black, brown, and mottled. I also crossed a barb with a spot, which is a white
        bird with a red tail and red spot on the forehead, and which notoriously breeds very true;
        the mongrels were dusky and mottled. I then crossed one of the mongrel barb-fantails with a
        mongrel barb-spot, and they produced a bird of as beautiful a blue colour, with the white
        loins, double black wing-bar, and barred and white-edged tail-feathers, as any wild rock
        pigeon! We can understand these facts, on the well-known principle of reversion to ancestral
        characters, if all the domestic breeds are descended from the rock pigeon. But if we deny
        this, we must make one of the two following highly improbable suppositions. Either, first,
        that all the several imagined aboriginal stocks were coloured and marked like the rock
        pigeon, although no other existing species is thus coloured and marked, so that in each
        separate breed there might be a tendency to revert to the very same colours and markings.
        Or, secondly, that each breed, even the purest, has within a dozen, or at most within a
        score, of generations, been crossed by the rock pigeon; I say within a dozen or twenty
        generations, for no instance is known of crossed descendants reverting to an ancestor of
        foreign blood, removed by a greater number of generations. In a breed which has been crossed
        only once, the tendency to revert to any character derived from such a cross will naturally
        become less and less, as in each succeeding generation there will be less of the foreign
        blood; but when there has been no cross, and there is a tendency in the breed to revert to a
        character which was lost during some former generation, this tendency, for all that we can
        see to the contrary, may be transmitted undiminished for an indefinite number of
        generations. These two distinct cases of reversion are often confounded together by those
        who have written on inheritance. Lastly, the hybrids or mongrels from between all the breeds
        of the pigeon are perfectly fertile, as I can state from my own observations, purposely
        made, on the most distinct breeds. Now, hardly any cases have been ascertained with
        certainty of hybrids from two quite distinct species of animals being perfectly fertile.
        Some authors believe that long-continued domestication eliminates this strong tendency to
        sterility in species. From the history of the dog, and of some other domestic animals, this
        conclusion is probably quite correct, if applied to species closely related to each other.
        But to extend it so far as to suppose that species, aboriginally as distinct as carriers,
        tumblers, pouters, and fantails now are, should yield offspring perfectly fertile inter se ,
        would be rash in the extreme. From these several reasons, namely, — the improbability of man
        having formerly made seven or eight supposed species of pigeons to breed freely under
        domestication; — these supposed species being quite unknown in a wild state, and their not
        having become anywhere feral; — these species presenting certain very abnormal characters,
        as compared with all other Columbidæ, though so like the rock-pigeon in most respects; — the
        occasional re-appearance of the blue colour and various black marks in all the breeds, both
        when kept pure and when crossed; — and lastly, the mongrel offspring being perfectly
        fertile; — from these several reasons, taken together, we may safely conclude that all our
        domestic breeds are descended from the rock-pigeon or Columba livia with its geographical
        sub-species. In favour of this view, I may add, firstly, that the wild C. livia has been
        found capable of domestication in Europe and in India; and that it agrees in habits and in a
        great number of points of structure with all the domestic breeds. Secondly, that, although
        an English carrier or a short-faced tumbler differs immensely in certain characters from the
        rock-pigeon, yet that, by comparing the several sub-breeds of these two races, more
        especially those brought from distant countries, we can make, between them and the rock
        pigeon, an almost perfect series; so we can in some other cases, but not with all the
        breeds. Thirdly, those characters which are mainly distinctive of each breed are in each
        eminently variable, for instance the wattle and length of beak of the carrier, the shortness
        of that of the tumbler, and the number of tail-feathers in the fantail; and the explanation
        of this fact will be obvious when we treat of Selection. Fourthly, pigeons have been watched
        and tended with the utmost care, and loved by many people. They have been domesticated for
        thousands of years in several quarters of the world; the earliest known record of pigeons is
        in the fifth ægyptian dynasty, about 3000 B.C., as was pointed out to me by Professor
        Lepsius; but Mr. Birch informs me that pigeons are given in a bill of fare in the previous
        dynasty. In the time of the Romans, as we hear from Pliny, immense prices were given for
        pigeons; \"nay, they are come to this pass, that they can reckon up their pedigree and
        race.\" Pigeons were much valued by Akber Khan in India, about the year 1600; never less
        than 20,000 pigeons were taken with the court. \"The monarchs of Iran and Turan sent him
        some very rare birds\"; and, continues the courtly historian, \"His Majesty by crossing the
        breeds, which method was never practised before, has improved them astonishingly.\" About
        this same period the Dutch were as eager about pigeons as were the old Romans. The paramount
        importance of these considerations in explaining the immense amount of variation which
        pigeons have undergone, will likewise be obvious when we treat of Selection. We shall then,
        also, see how it is that the several breeds so often have a somewhat monstrous character. It
        is also a most favourable circumstance for the production of distinct breeds, that male and
        female pigeons can be easily mated for life; and thus different breeds can be kept together
        in the same aviary. I have discussed the probable origin of domestic pigeons at some, yet
        quite insufficient, length; because when I first kept pigeons and watched the several kinds,
        well knowing how truly they breed, I felt fully as much difficulty in believing that since
        they had been domesticated they had all proceeded from a common parent, as any naturalist
        could in coming to a similar conclusion in regard to the many species of finches, or other
        groups of birds, in nature. One circumstance has struck me much; namely, that nearly all the
        breeders of the various domestic animals and the cultivators of plants, with whom I have
        conversed, or whose treatises I have read, are firmly convinced that the several breeds to
        which each has attended, are descended from so many aboriginally distinct species. Ask, as I
        have asked, a celebrated raiser of Hereford cattle, whether his cattle might not have
        descended from Long-horns, or both from a common parent-stock, and he will laugh you to
        scorn. I have never met a pigeon, or poultry, or duck, or rabbit fancier, who was not fully
        convinced that each main breed was descended from a distinct species. Van Mons, in his
        treatise on pears and apples, shows how utterly he disbelieves that the several sorts, for
        instance a Ribston-pippin or Codlin-apple, could ever have proceeded from the seeds of the
        same tree. Innumerable other examples could be given. The explanation, I think, is simple:
        from long-continued study they are strongly impressed with the differences between the
        several races; and though they well know that each race varies slightly, for they win their
        prizes by selecting such slight differences, yet they ignore all general arguments, and
        refuse to sum up in their minds slight differences accumulated during many successive
        generations. May not those naturalists who, knowing far less of the laws of inheritance than
        does the breeder, and knowing no more than he does of the intermediate links in the long
        lines of descent, yet admit that many of our domestic races are descended from the same
        parents — may they not learn a lesson of caution, when they deride the idea of species in a
        state of nature being lineal descendants of other species? Principles of Selection anciently
        followed , and their Effects. Let us now briefly consider the steps by which domestic races
        have been produced, either from one or from several allied species. Some effect may be
        attributed to the direct and definite action of the external conditions of life, and some to
        habit; but he would be a bold man who would account by such agencies for the differences
        between a dray and race horse, a greyhound and bloodhound, a carrier and tumbler pigeon. One
        of the most remarkable features in our domesticated races is that we see in them adaptation,
        not indeed to the animal's or plant's own good, but to man's use or fancy. Some variations
        useful to him have probably arisen suddenly, or by one step; many botanists, for instance,
        believe that the fuller's teasel, with its hooks, which cannot be rivalled by any mechanical
        contrivance, is only a variety of the wild Dipsacus; and this amount of change may have
        suddenly arisen in a seedling. So it has probably been with the turnspit dog; and this is
        known to have been the case with the ancon sheep. But when we compare the dray-horse and
        race-horse, the dromedary and camel, the various breeds of sheep fitted either for
        cultivated land or mountain pasture, with the wool of one breed good for one purpose, and
        that of another breed for another purpose; when we compare the many breeds of dogs, each
        good for man in different ways; when we compare the game-cock, so pertinacious in battle,
        with other breeds so little quarrelsome, with \"everlasting layers\" which never desire to
        sit, and with the bantam so small and elegant; when we compare the host of agricultural,
        culinary, orchard, and flower-garden races of plants, most useful to man at different
        seasons and for different purposes, or so beautiful in his eyes, we must, I think, look
        further than to mere variability. We cannot suppose that all the breeds were suddenly
        produced as perfect and as useful as we now see them; indeed, in many cases, we know that
        this has not been their history. The key is man's power of accumulative selection: nature
        gives successive variations; man adds them up in certain directions useful to him. In this
        sense he may be said to have made for himself useful breeds. The great power of this
        principle of selection is not hypothetical. It is certain that several of our eminent
        breeders have, even within a single lifetime, modified to a large extent their breeds of
        cattle and sheep. In order fully to realise what they have done, it is almost necessary to
        read several of the many treatises devoted to this subject, and to inspect the animals.
        Breeders habitually speak of an animal's organisation as something plastic, which they can
        model almost as they please. If I had space I could quote numerous passages to this effect
        from highly competent authorities. Youatt, who was probably better acquainted with the works
        of agriculturists than almost any other individual, and who was himself a very good judge of
        animals, speaks of the principle of selection as \"that which enables the agriculturist, not
        only to modify the character of his flock, but to change it altogether. It is the magician's
        wand, by means of which he may summon into life whatever form and mould he pleases.\" Lord
        Somerville, speaking of what breeders have done for sheep, says: — \"It would seem as if
        they had chalked out upon a wall a form perfect in itself, and then had given it
        existence.\" In Saxony the importance of the principle of selection in regard to merino
        sheep is so fully recognised, that men follow it as a trade; the sheep are placed on a table
        and are studied, like a picture by a connoisseur; this is done three times at intervals of
        months, and the sheep are each time marked and classed, so that the very best may ultimately
        be selected for breeding. What English breeders have actually effected is proved by the
        enormous prices given for animals with a good pedigree; and these have been exported to
        almost every quarter of the world. The improvement is by no means generally due to crossing
        different breeds; all the best breeders are strongly opposed to this practice, except
        sometimes amongst closely allied sub-breeds. And when a cross has been made, the closest
        selection is far more indispensable even than in ordinary cases. If selection consisted
        merely in separating some very distinct variety, and breeding from it, the principle would
        be so obvious as hardly to be worth notice; but its importance consists in the great effect
        produced by the accumulation in one direction, during successive generations, of differences
        absolutely inappreciable by an uneducated eye — differences which I for one have vainly
        attempted to appreciate. Not one man in a thousand has accuracy of eye and judgment
        sufficient to become an eminent breeder. If gifted with these qualities, and he studies his
        subject for years, and devotes his lifetime to it with indomitable perseverance, he will
        succeed, and may make great improvements; if he wants any of these qualities, he will
        assuredly fail. Few would readily believe in the natural capacity and years of practice
        requisite to become even a skilful pigeon-fancier. The same principles are followed by
        horticulturists; but the variations are here often more abrupt. No one supposes that our
        choicest productions have been produced by a single variation from the aboriginal stock. We
        have proofs that this has not been so in several cases in which exact records have been
        kept; thus, to give a very trifling instance, the steadily-increasing size of the common
        gooseberry may be quoted. We see an astonishing improvement in many florists' flowers, when
        the flowers of the present day are compared with drawings made only twenty or thirty years
        ago. When a race of plants is once pretty well established, the seed-raisers do not pick out
        the best plants, but merely go over their seed-beds, and pull up the \"rogues,\" as they
        call the plants that deviate from the proper standard. With animals this kind of selection
        is, in fact, likewise followed; for hardly any one is so careless as to breed from his worst
        animals. In regard to plants, there is another means of observing the accumulated effects of
        selection — namely, by comparing the diversity of flowers in the different varieties of the
        same species in the flower-garden; the diversity of leaves, pods, or tubers, or whatever
        part is valued, in the kitchen-garden, in comparison with the flowers of the same varieties;
        and the diversity of fruit of the same species in the orchard, in comparison with the leaves
        and flowers of the same set of varieties. See how different the leaves of the cabbage are,
        and how extremely alike the flowers; how unlike the flowers of the heartsease are, and how
        alike the leaves; how much the fruit of the different kinds of gooseberries differ in size,
        colour, shape, and hairiness, and yet the flowers present very slight differences. It is not
        that the varieties which differ largely in some one point do not differ at all in other
        points; this is hardly ever, — I speak after careful observation, — perhaps never, the case.
        The law of correlated variation, the importance of which should never be overlooked, will
        ensure some differences; but, as a general rule, it cannot be doubted that the continued
        selection of slight variations, either in the leaves, the flowers, or the fruit, will
        produce races differing from each other chiefly in these characters. It may be objected that
        the principle of selection has been reduced to methodical practice for scarcely more than
        three-quarters of a century; it has certainly been more attended to of late years, and many
        treatises have been published on the subject; and the result has been, in a corresponding
        degree, rapid and important. But it is very far from true that the principle is a modern
        discovery. I could give several references to works of high antiquity, in which the full
        importance of the principle is acknowledged. In rude and barbarous periods of English
        history choice animals were often imported, and laws were passed to prevent their
        exportation: the destruction of horses under a certain size was ordered, and this may be
        compared to the \"roguing\" of plants by nurserymen. The principle of selection I find
        distinctly given in an ancient Chinese ency- clopædia. Explicit rules are laid down by some
        of the Roman classical writers. From passages in Genesis, it is clear that the colour of
        domestic animals was at that early period attended to. Savages now sometimes cross their
        dogs with wild canine animals, to improve the breed, and they formerly did so, as is
        attested by passages in Pliny. The savages in South Africa match their draught cattle by
        colour, as do some of the Esquimaux their teams of dogs. Livingstone states that good
        domestic breeds are highly valued by the negroes in the interior of Africa who have not
        associated with Europeans. Some of these facts do not show actual selection, but they show
        that the breeding of domestic animals was carefully attended to in ancient times, and is now
        attended to by the lowest savages. It would, indeed, have been a strange fact, had attention
        not been paid to breeding, for the inheritance of good and bad qualities is so obvious.
        Unconscious Selection. At the present time, eminent breeders try by methodical selection,
        with a distinct object in view, to make a new strain or sub-breed, superior to anything of
        the kind in the country. But, for our purpose, a form of Selection, which may be called
        Unconscious, and which results from every one trying to possess and breed from the best
        individual animals, is more important. Thus, a man who intends keeping pointers naturally
        tries to get as good dogs as he can, and afterwards breeds from his own best dogs, but he
        has no wish or expectation of permanently altering the breed. Nevertheless we may infer that
        this process, continued during centuries, would improve and modify any breed, in the same
        way as Bakewell, Collins, &amp;c., by this very same process, only carried on more
        methodically, did greatly modify, even during their lifetimes, the forms and qualities of
        their cattle. Slow and insensible changes of this kind can never be recognised unless actual
        measurements or careful drawings of the breeds in question have been made long ago, which
        may serve for comparison. In some cases, however, unchanged, or but little changed
        individuals of the same breed exist in less civilised districts, where the breed has been
        less improved. There is reason to believe that King Charles's spaniel has been unconsciously
        modified to a large extent since the time of that monarch. Some highly competent authorities
        are convinced that the setter is directly derived from the spaniel, and has probably been
        slowly altered from it. It is known that the English pointer has been greatly changed within
        the last century, and in this case the change has, it is believed, been chiefly effected by
        crosses with the foxhound; but what concerns us is, that the change has been effected
        unconsciously and gradually, and yet so effectually, that, though the old Spanish pointer
        certainly came from Spain, Mr. Borrow has not seen, as I am informed by him, any native dog
        in Spain like our pointer. By a similar process of selection, and by careful training,
        English racehorses have come to surpass in fleetness and size the parent Arabs, so that the
        latter, by the regulations for the Goodwood Races, are favoured in the weights which they
        carry. Lord Spencer and others have shown how the cattle of England have increased in weight
        and in early maturity, compared with the stock formerly kept in this country. By comparing
        the accounts given in various old treatises of the former and present state of carrier and
        tumbler pigeons in Britain, India, and Persia, we can trace the stages through which they
        have insensibly passed, and come to differ so greatly from the rock-pigeon. Youatt gives an
        excellent illustration of the effects of a course of selection, which may be considered as
        unconscious, in so far that the breeders could never have expected, or even wished, to
        produce the result which ensued — namely, the production of two distinct strains. The two
        flocks of Leicester sheep kept by Mr. Buckley and Mr. Burgess, as Mr. Youatt remarks, \"have
        been purely bred from the original stock of Mr. Bakewell for upwards of fifty years. There
        is not a suspicion existing in the mind of any one at all acquainted with the subject, that
        the owner of either of them has deviated in any one instance from the pure blood of Mr.
        Bakewell's flock, and yet the difference between the sheep possessed by these two gentlemen
        is so great that they have the appearance of being quite different varieties.\" If there
        exist savages so barbarous as never to think of the inherited character of the offspring of
        their domestic animals, yet any one animal particularly useful to them, for any special
        purpose, would be carefully preserved during famines and other accidents, to which savages
        are so liable, and such choice animals would thus generally leave more offspring than the
        inferior ones; so that in this case there would be a kind of unconscious selection going on.
        We see the value set on animals even by the barbarians of Tierra del Fuego, by their killing
        and devouring their old women, in times of dearth, as of less value than their dogs. In
        plants the same gradual process of improvement, through the occasional preservation of the
        best individuals, whether or not sufficiently distinct to be ranked at their first
        appearance as distinct varieties, and whether or not two or more species or races have
        become blended together by crossing, may plainly be recognised in the increased size and
        beauty which we now see in the varieties of the heartsease, rose, pelargonium, dahlia, and
        other plants, when compared with the older varieties or with their parent-stocks. No one
        would ever expect to get a first-rate heartsease or dahlia from the seed of a wild plant. No
        one would expect to raise a first-rate melting pear from the seed of the wild pear, though
        he might succeed from a poor seedling growing wild, if it had come from a garden-stock. The
        pear, though cultivated in classical times, appears, from Pliny's description, to have been
        a fruit of very inferior quality. I have seen great surprise expressed in horticultural
        works at the wonderful skill of gardeners, in having produced such splendid results from
        such poor materials; but the art has been simple, and, as far as the final result is
        concerned, has been followed almost unconsciously. It has consisted in always cultivating
        the best known variety, sowing its seeds, and, when a slightly better variety chanced to
        appear, selecting it, and so onwards. But the gardeners of the classical period, who
        cultivated the best pears which they could procure, never thought what splendid fruit we
        should eat; though we owe our excellent fruit, in some small degree, to their having
        naturally chosen and preserved the best varieties they could anywhere find. A large amount
        of change, thus slowly and unconsciously accumulated, explains, as I believe, the well-known
        fact, that in a number of cases we cannot recognise, and therefore do not know, the wild
        parent-stocks of the plants which have been longest cultivated in our flower and kitchen
        gardens. If it has taken centuries or thousands of years to improve or modify most of our
        plants up to their present standard of usefulness to man, we can understand how it is that
        neither Australia, the Cape of Good Hope, nor any other region inhabited by quite
        uncivilised man, has afforded us a single plant worth culture. It is not that these
        countries, so rich in species, do not by a strange chance possess the aboriginal stocks of
        any useful plants, but that the native plants have not been improved by continued selection
        up to a standard of perfection comparable with that acquired by the plants in countries
        anciently civilised. In regard to the domestic animals kept by uncivilised man, it should
        not be overlooked that they almost always have to struggle for their own food, at least
        during certain seasons. And in two countries very differently circumstanced, individuals of
        the same species, having slightly different constitutions or structure, would often succeed
        better in the one country than in the other; and thus by a process of \"natural selection,\"
        as will hereafter be more fully explained, two sub-breeds might be formed. This, perhaps,
        partly explains why the varieties kept by savages, as has been remarked by some authors,
        have more of the character of true species than the varieties kept in civilised countries.
        On the view here given of the important part which selection by man has played, it becomes
        at once obvious, how it is that our domestic races show adaptation in their structure or in
        their habits to man's wants or fancies. We can, I think, further understand the frequently
        abnormal character of our domestic races, and likewise their differences being so great in
        external characters, and relatively so slight in internal parts or organs. Man can hardly
        select, or only with much difficulty, any deviation of structure excepting such as is
        externally visible; and indeed he rarely cares for what is internal. He can never act by
        selection, excepting on variations which are first given to him in some slight degree by
        nature. No man would ever try to make a fantail till he saw a pigeon with a tail developed
        in some slight degree in an unusual manner, or a pouter till he saw a pigeon with a crop of
        somewhat unusual size; and the more abnormal or unusual any character was when it first
        appeared, the more likely it would be to catch his attention. But to use such an expression
        as trying to make a fantail, is, I have no doubt, in most cases, utterly incorrect. The man
        who first selected a pigeon with a slightly larger tail, never dreamed what the descendants
        of that pigeon would become through long-continued, partly unconscious and partly
        methodical, selection. Perhaps the parent-bird of all fantails had only fourteen
        tail-feathers somewhat expanded, like the present Java fantail, or like individuals of other
        and distinct breeds, in which as many as seventeen tail-feathers have been counted. Perhaps
        the first pouter-pigeon did not inflate its crop much more than the turbit now does the
        upper part of its œsophagus, — a habit which is disregarded by all fanciers, as it is not
        one of the points of the breed. Nor let it be thought that some great deviation of structure
        would be necessary to catch the fancier's eye: he perceives extremely small differences, and
        it is in human nature to value any novelty, however slight, in one's own possession. Nor
        must the value which would formerly have been set on any slight differences in the
        individuals of the same species, be judged of by the value which is now set on them, after
        several breeds have fairly been established. It is known that with pigeons many slight
        variations now occasionally appear, but these are rejected as faults or deviations from the
        standard of perfection in each breed. The common goose has not given rise to any marked
        varieties; hence the Toulouse and the common breed, which differ only in colour, that most
        fleeting of characters, have lately been exhibited as distinct at our poultry-shows. These
        views appear to explain what has sometimes been noticed — namely, that we know hardly
        anything about the origin or history of any of our domestic breeds. But, in fact, a breed,
        like a dialect of a language, can hardly be said to have a distinct origin. A man preserves
        and breeds from an individual with some slight deviation of structure, or takes more care
        than usual in matching his best animals, and thus improves them, and the improved animals
        slowly spread in the immediate neighbourhood. But they will as yet hardly have a distinct
        name, and from being only slightly valued, their history will have been disregarded. When
        further improved by the same slow and gradual process, they will spread more widely, and
        will be recognised as something distinct and valuable, and will then probably first receive
        a provincial name. In semi-civilised countries, with little free communication, the
        spreading of a new sub-breed would be a slow process. As soon as the points of value are
        once acknowledged, the principle, as I have called it, of unconscious selection will always
        tend, — perhaps more at one period than at another, as the breed rises or falls in fashion,
        — perhaps more in one district than in another, according to the state of civilisation of
        the inhabitants, — slowly to add to the characteristic features of the breed, whatever they
        may be. But the chance will be infinitely small of any record having been preserved of such
        slow, varying, and insensible changes. Circumstances favourable to Man ' s Power of
        Selection. I will now say a few words on the circumstances, favourable, or the reverse, to
        man's power of selection. A high degree of variability is obviously favourable, as freely
        giving the materials for selection to work on; not that mere individual differences are not
        amply sufficient, with extreme care, to allow of the accumulation of a large amount of
        modification in almost any desired direction. But as variations manifestly useful or
        pleasing to man appear only occasionally, the chance of their appearance will be much
        increased by a large number of individuals being kept. Hence, number is of the highest
        importance for success. On this principle Marshall formerly remarked, with respect to the
        sheep of parts of Yorkshire, \"as they generally belong to poor people, and are mostly in
        small lots , they never can be improved.\" On the other hand, nurserymen, from keeping large
        stocks of the same plant, are generally far more successful than amateurs in raising new and
        valuable varieties. A large number of individuals of an animal or plant can be reared only
        where the conditions for its propagation are favourable. When the individuals are scanty,
        all will be allowed to breed, whatever their quality may be, and this will effectually
        prevent selection. But probably the most important element is that the animal or plant
        should be so highly valued by man, that the closest attention is paid to even the slightest
        deviations in its qualities or structure. Unless such attention be paid nothing can be
        effected. I have seen it gravely remarked, that it was most fortunate that the strawberry
        began to vary just when gardeners began to attend to this plant. No doubt the strawberry had
        always varied since it was cultivated, but the slight varieties had been neglected. As soon,
        however, as gardeners picked out individual plants with slightly larger, earlier, or better
        fruit, and raised seedlings from them, and again picked out the best seedlings and bred from
        them, then (with some aid by crossing distinct species) those many admirable varieties of
        the strawberry were raised which have appeared during the last half-century. With animals,
        facility in preventing crosses is an important element in the formation of new races, — at
        least, in a country which is already stocked with other races. In this respect enclosure of
        the land plays a part. Wandering savages or the inhabitants of open plains rarely possess
        more than one breed of the same species. Pigeons can be mated for life, and this is a great
        convenience to the fancier, for thus many races may be improved and kept true, though
        mingled in the same aviary; and this circumstance must have largely favoured the formation
        of new breeds. Pigeons, I may add, can be propagated in great numbers and at a very quick
        rate, and inferior birds may be freely rejected, as when killed they serve for food. On the
        other hand, cats, from their nocturnal rambling habits, cannot be easily matched, and,
        although so much valued by women and children, we rarely see a distinct breed long kept up;
        such breeds as we do sometimes see are almost always imported from some other country.
        Although I do not doubt that some domestic animals vary less than others, yet the rarity or
        absence of distinct breeds of the cat, the donkey, peacock, goose, &amp;c., may be
        attributed in main part to selection not having been brought into play: in cats, from the
        difficulty in pairing them; in donkeys, from only a few being kept by poor people, and
        little attention paid to their breeding; for recently in certain parts of Spain and of the
        United States this animal has been surprisingly modified and improved by careful selection;
        in peacocks, from not being very easily reared and a large stock not kept; in geese, from
        being valuable only for two purposes, food and feathers, and more especially from no
        pleasure having been felt in the display of distinct breeds; but the goose, under the
        conditions to which it is exposed when domesticated, seems to have a singularly inflexible
        organisation, though it has varied to a slight extent, as I have elsewhere described. Some
        authors have maintained that the amount of variation in our domestic productions is soon
        reached, and can never afterwards be exceeded. It would be somewhat rash to assert that the
        limit has been attained in any one case; for almost all our animals and plants have been
        greatly improved in many ways within a recent period; and this implies variation. It would
        be equally rash to assert that characters now increased to their utmost limit, could not,
        after remaining fixed for many centuries, again vary under new conditions of life. No doubt,
        as Mr. Wallace has remarked with much truth, a limit will be at last reached. For instance,
        there must be a limit to the fleetness of any terrestrial animal, as this will be determined
        by the friction to be overcome, the weight of body to be carried, and the power of
        contraction in the muscular fibres. But what concerns us is that the domestic varieties of
        the same species differ from each other in almost every character, which man has attended to
        and selected, more than do the distinct species of the same genera. Isidore Geoffroy St.
        Hilaire has proved this in regard to size, and so it is with colour and probably with the
        length of hair. With respect to fleetness, which depends on many bodily characters, Eclipse
        was far fleeter, and a dray-horse is incomparably stronger than any two natural species
        belonging to the same genus. So with plants, the seeds of the different varieties of the
        bean or maize probably differ more in size, than do the seeds of the distinct species in any
        one genus in the same two families. The same remark holds good in regard to the fruit of the
        several varieties of the plum, and still more strongly with the melon, as well as in many
        other analogous cases. To sum up on the origin of our domestic races of animals and plants.
        Changed conditions of life are of the highest importance in causing variability, both by
        acting directly on the organisation, and indirectly by affecting the reproductive system. It
        is not probable that variability is an inherent and necessary contingent, under all
        circumstances. The greater or less force of inheritance and reversion determine whether
        variations shall endure. Variability is governed by many unknown laws, of which correlated
        growth is probably the most important. Something, but how much we do not know, may be
        attributed to the definite action of the conditions of life. Some, perhaps a great, effect
        may be attributed to the increased use or disuse of parts. The final result is thus rendered
        infinitely complex. In some cases the intercrossing of aboriginally distinct species appears
        to have played an important part in the origin of our breeds. When several breeds have once
        been formed in any country, their occasional intercrossing, with the aid of selection, has,
        no doubt, largely aided in the formation of new sub-breeds; but the importance of crossing
        has been much exaggerated, both in regard to animals and to those plants which are
        propagated by seed. With plants which are temporarily propagated by cuttings, buds, &amp;c.,
        the importance of crossing is immense; for the cultivator may here disregard the extreme
        variability both of hybrids and of mongrels, and the sterility of hybrids; but plants not
        propagated by seed are of little importance to us, for their endurance is only temporary.
        Over all these causes of Change, the accumulative action of Selection, whether applied
        methodically and quickly, or unconsciously and slowly but more efficiently, seems to have
        been the predominant Power. </xsl:variable>
    <xsl:variable name="woolf_uk" as="xs:string">When she looked in the glass and saw her hair grey,
        her cheek sunk, at fifty, she thought, possibly she might have managed things better—her
        husband; money; his books. But for her own part she would never for a single second regret
        her decision, evade difficulties, or slur over duties. She was now formidable to behold, and
        it was only in silence, looking up from their plates, after she had spoken so severely about
        Charles Tansley, that her daughters—Prue, Nancy, Rose—could sport with infidel ideas which
        they had brewed for themselves of a life different from hers; in Paris, perhaps; a wilder
        life; not always taking care of some man or other; for there was in all their minds a mute
        questioning of deference and chivalry, of the Bank of England and the Indian Empire, of
        ringed fingers and lace, though to them all there was something in this of the essence of
        beauty, which called out the manliness in their girlish hearts, and made them, as they sat
        at table beneath their mother’s eyes, honour her strange severity, her extreme courtesy,
        like a Queen’s raising from the mud a beggar’s dirty foot and washing, when she thus
        admonished them so very severely about that wretched atheist who had chased them—or,
        speaking accurately, been invited to stay with them—in the Isle of Skye.</xsl:variable>
    <xsl:variable name="woolf_us" as="xs:string">When she looked in the glass and saw her hair grey,
        her cheek sunk, at fifty, she thought, possibly she might have managed things better—her
        husband; money; his books. But for her own part she would never for a single second regret
        her decision, evade difficulties, or slur over duties. She was now formidable to behold, and
        it was only in silence, looking up from their plates, after she had spoken so severely about
        Charles Tansley, that her daughters, Prue, Nancy, Rose—could sport with infidel ideas which
        they had brewed for themselves of a life different from hers; in Paris, perhaps; a wilder
        life; not always taking care of some man or other; for there was in all their minds a mute
        questioning of deference and chivalry, of the Bank of England and the Indian Empire, of
        ringed fingers and lace, though to them all there was something in this of the essence of
        beauty, which called out the manliness in their girlish hearts, and made them, as they sat
        at table beneath their mother’s eyes, honour her strange severity, her extreme courtesy,
        like a Queen’s raising from the mud to wash a beggar’s dirty foot, when she thus admonished
        them so very severely about that wretched atheist who had chased them—or, speaking
        accurately, been invited to stay with them—in the Isles of Skye.</xsl:variable>
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- scoring (may be altered):                              -->
    <!--   match    =  1                                        -->
    <!--   mismatch = -1                                        -->
    <!--   gap      = -2                                        -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:variable name="match_score" as="xs:integer" select="1"/>
    <xsl:variable name="mismatch_score" as="xs:integer" select="-1"/>
    <xsl:variable name="gap_score" as="xs:integer" select="-2"/>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- user-defined functions                                    -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:get_diag_cells()                                      -->
    <!-- returns all cell in specified diagonal .                  -->
    <!-- parameters:                                               -->
    <!--   $diag as xs:integer                                     -->
    <!--   @left_len xs:integer (total number of rows)             -->
    <!--   @ltop_len xs:integer (total number of columns)          -->
    <!-- return: <diag>, with $diag as @n and <cell> contents      -->
    <!--   note: <cell> elements specify @row and @col             -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:get_diag_cells" as="element(diag)+">
        <xsl:param name="diag" as="xs:integer"/>
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- trap input errors                                     -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:if test="($diag, $left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$diag, $top_len, and $left_len must all be positive integers'"/>
        </xsl:if>
        <xsl:if test="$diag gt sum(($top_len, $left_len, -1))">
            <xsl:message terminate="yes"
                select="'$diag cannot be greater than $left_len + $top_len - 1'"/>
        </xsl:if>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- $row_start is 1 until $top_len (last row), then       -->
        <!--   augment by $diag - $top_len to shift down one row   -->
        <!--   (wrapping around upper right corner)                -->
        <!-- $col is $diag - $row + 1 (otherwise would start at 0, -->
        <!--   since $diag 1 has [1,1])                            -->
        <!-- based on https://www.jenitennison.com/2007/05/06/     -->
        <!--   levenshtein-distance-on-the-diagonal.html           -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="shift" as="xs:integer"
            select="
                if ($diag gt $top_len) then
                    ($diag - $top_len)
                else
                    0"/>
        <xsl:variable name="row_start" as="xs:integer" select="1 + $shift"/>
        <xsl:variable name="row_end" as="xs:integer" select="min(($diag, $left_len))"/>
        <diag n="{$diag}">
            <xsl:for-each select="$row_start to $row_end">
                <xsl:variable name="row" as="xs:integer" select="."/>
                <xsl:variable name="col" as="xs:integer" select="$diag - $row + 1"/>
                <cell row="{$row}" col="{$col}"/>
            </xsl:for-each>
            <!-- create row and column 0 where needed -->
            <xsl:if test="$diag lt $top_len">
                <xsl:variable name="tmp" as="xs:integer" select="$diag + 1"/>
                <cell row="0" col="{$tmp}" score="{$tmp}" gap_score="{$tmp * $gap_score}"
                    source="'l'"/>
            </xsl:if>
            <xsl:if test="$diag lt $left_len">
                <xsl:variable name="tmp" as="xs:integer" select="$diag + 1"/>
                <cell row="{$tmp}" col="0" score="{$tmp}" gap_score="{$tmp * $gap_score}"/>
            </xsl:if>
        </diag>
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:create_grid()                                         -->
    <!-- finds all cells in grid, organized by diagonal            -->
    <!-- parameters:                                               -->
    <!--   $left_len as xs:integer .                               -->
    <!--   $top_len as xs:integer                                  -->
    <!-- returns:                                                  -->
    <!--   element(diag)+ (from djb:get_diag_cells)                -->
    <!-- dependencies:                                             -->
    <!--   calls djb:get_diag_cells() for each diagonal            -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:create_grid" as="element(diag)+">
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <xsl:if test="($left_len, $top_len) &lt; 1">
            <xsl:message terminate="yes"
                select="'$left_len and $top_len must both be positive integers'"/>
        </xsl:if>
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>
        <xsl:for-each select="1 to $diag_count">
            <xsl:sequence select="djb:get_diag_cells(., $left_len, $top_len)"/>
        </xsl:for-each>
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:tokenize_input()                                      -->
    <!-- finds all cells in grid, organized by diagonal            -->
    <!-- parameters:                                               -->
    <!--   $top as xs:string                                       -->
    <!--   $left as xs:string .                                    -->
    <!-- returns:                                                  -->
    <!--   map:                                                    -->
    <!--     top: tokenized input as xs:string+                    -->
    <!--     left: tokenized input as xs:string+                   -->
    <!--     type: 'words' or 'characters'                         -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:tokenize_input" as="map(xs:string, item()+)">
        <xsl:param name="top" as="xs:string"/>
        <xsl:param name="left" as="xs:string"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- normalize whitespace                                  -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top_n" as="xs:string" select="normalize-space($top)"/>
        <xsl:variable name="left_n" as="xs:string" select="normalize-space($left)"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- validate input                                        -->
        <!-- no null strings                                       -->
        <!-- both strings must be either single- or multiple-word  -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:if test="(string-length($top_n), string-length($left_n)) = 0">
            <xsl:message select="'Null strings are not permitted'" terminate="yes"/>
        </xsl:if>
        <xsl:if
            test="
                not(
                (matches($top_n, '\s') and matches($left_n, '\s'))
                or
                not(matches($top_n, '\s')) and not(matches($left_n, '\s'))
                )">
            <xsl:message
                select="'Either both strings must be single words or both strings must be multiple words'"
                terminate="yes"/>
        </xsl:if>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- split the inputs                                      -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="top_out" as="xs:string+"
            select="
                if (matches($top_n, '\s')) then
                    tokenize($top_n, '\s+')
                else
                    for $c in string-to-codepoints($top_n)
                    return
                        codepoints-to-string($c)"/>
        <xsl:variable name="left_out" as="xs:string+"
            select="
                if (matches($left_n, '\s')) then
                    tokenize($left_n, '\s+')
                else
                    for $c in string-to-codepoints($left_n)
                    return
                        codepoints-to-string($c)"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- are we returning characters or words?                 -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="input_type" as="xs:string+"
            select="
                if (matches($top_n, '\s')) then
                    'words'
                else
                    'characters'"/>

        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- return tokenized sequences and type in map            -->
        <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:sequence
            select="
                map {
                    'top': $top_out,
                    'left': $left_out,
                    'type': $input_type
                }"
        />
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:grid_to_html()                                        -->
    <!-- outputs alignment grid as HTML table                      -->
    <!-- parameters:                                               -->
    <!--   in as element(cell)+                                    -->
    <!-- returns:                                                  -->
    <!--   HTML document                                           -->
    <!-- note: diagnostic only; not used in production             -->
    <!--   to use, set iterator to return $cumulative              -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:grid_to_html" as="element(html:html)">
        <xsl:param name="in" as="element(cell)+"/>
        <xsl:param name="top" as="xs:string+"/>
        <xsl:param name="left" as="xs:string+"/>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>test</title>
            </head>
            <body>
                <table border="1">
                    <tr>
                        <td>&#xa0;</td>
                        <td>&#xa0;</td>
                        <xsl:for-each select="$left">
                            <td>
                                <xsl:sequence select="."/>
                            </td>
                        </xsl:for-each>
                    </tr>
                    <xsl:for-each select="distinct-values($in/@row)">
                        <xsl:sort/>
                        <xsl:variable name="row" as="xs:integer" select="."/>
                        <tr>
                            <xsl:sequence select="($top[$row], '&#xa0;')[1]"/>
                            <xsl:for-each select="$in[@row = $row]">
                                <xsl:sort select="@col"/>
                                <td>
                                    <xsl:value-of select="@score, @path"/>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:find_path()                                           -->
    <!-- generates alignment grid, recording full paths            -->
    <!-- parameters:                                               -->
    <!--   $diag_count as xs:integer                               -->
    <!--   $left_len as xs:integer                                 -->
    <!--   $top_len as xs:integer                                  -->
    <!--   $left_tokens as xs:string+                              -->
    <!--   $top_tokens as xs:string+                               -->
    <!-- returns:                                                  -->
    <!--   full optimal path as string of d, l, and u              -->
    <!-- notes:                                                    -->
    <!--   modify <xsl:on-completion> to change output .           -->
    <!--   can maintain cumulative grid as $cumulative, but this   -->
    <!--   is disabled by default for scalability and efficiency . -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- return type is normally xs:string; change to element(cell)+ for cumulative table output -->
    <xsl:function name="djb:find_path" as="xs:string">
        <xsl:param name="diag_count" as="xs:integer"/>
        <xsl:param name="left_len" as="xs:integer"/>
        <xsl:param name="top_len" as="xs:integer"/>
        <xsl:param name="left_tokens" as="xs:string+"/>
        <xsl:param name="top_tokens" as="xs:string+"/>
        <xsl:iterate select="1 to $diag_count">
            <!-- $ult and $penult hold the preceding two diags, with modification -->
            <xsl:param name="ult" as="element(cell)+">
                <cell row="1" col="0" score="{$gap_score ! number()}"
                    gap_score="{$gap_score ! number() * 2}" source="u" path="u"/>
                <cell row="0" col="1" score="{$gap_score}" gap_score="{$gap_score * 2}" source="l"
                    path="l"/>
            </xsl:param>
            <xsl:param name="penult" as="element(cell)*">
                <cell row="0" col="0" score="0"/>
            </xsl:param>
            <!-- uncomment for cumulative output -->
            <!--<xsl:param name="cumulative" as="element(cell)*" select="$penult | $ult"/>-->
            <xsl:on-completion>
                <!-- return lower right cell, with modification-->
                <xsl:value-of select="$ult/@path"/>
                <!--<xsl:sequence select="$cumulative => djb:grid_to_html($left_tokens, $top_tokens)"/>-->
                <!-- return this instead for full table -->
                <!--<xsl:sequence select="$cumulative"/>-->
                <!--<xsl:message select="$ult/@path"/>-->
            </xsl:on-completion>
            <xsl:variable name="current_diag" select="djb:get_diag_cells(., $left_len, $top_len)"/>
            <!-- search space as document for key use-->
            <xsl:variable name="search_space" as="document-node()">
                <xsl:document>
                    <xsl:sequence select="$ult | $penult"/>
                </xsl:document>
            </xsl:variable>
            <xsl:message
                select="'diag', current(), '/', $diag_count, ';', count($current_diag/cell), 'cells; search space', count($search_space/cell), 'cells'"/>
            <xsl:variable name="current" as="element(cell)+">
                <xsl:for-each select="$current_diag/cell">
                    <!-- is the current cell a match? -->
                    <xsl:variable name="current_match" as="xs:integer"
                        select="
                            if ($left_tokens[current()/number(@row)] eq $top_tokens[current()/number(@col)]) then
                                1
                            else
                                -1"/>
                    <!-- 
                        get three values, mapped to sources, sort (score, then source) and choose
                        $winner(2) will be source of best score (breaking ties as d, l, u)
                        $winner(1) will be the best score
                    -->
                    <xsl:variable name="d_cell" as="element(cell)?"
                        select="key('cellByRowCol', (number(@row) - 1, number(@col) - 1), $search_space)"/>
                    <xsl:variable name="l_cell" as="element(cell)?"
                        select="key('cellByRowCol', (number(@row), number(@col) - 1), $search_space)"/>
                    <xsl:variable name="u_cell" as="element(cell)?"
                        select="key('cellByRowCol', (number(@row) - 1, number(@col)), $search_space)"/>
                    <xsl:variable name="winners" as="element(winner)+">
                        <winner name="d" score="{$d_cell/number(@score) + $current_match}"
                            path="{$d_cell/@path}"/>
                        <winner name="l" score="{$l_cell/number(@gap_score)}" path="{$l_cell/@path}"/>
                        <winner name="u" score="{$u_cell/number(@gap_score)}" path="{$u_cell/@path}"
                        />
                    </xsl:variable>
                    <xsl:variable name="winners_sorted" as="element(winner)+">
                        <xsl:perform-sort select="$winners">
                            <xsl:sort select="@score" order="descending" data-type="number"/>
                            <xsl:sort select="@name"/>
                        </xsl:perform-sort>
                    </xsl:variable>
                    <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <!-- add 
                            $match (boolean)
                            $gap_score (not $match_score, since that will depend on @match in the new cell)
                            $source (source of score value)
                            $score (of new cell)
                        -->
                        <xsl:variable name="current_score" as="xs:integer"
                            select="$winners_sorted[1]/@score"/>
                        <xsl:attribute name="match" select="$current_match"/>
                        <xsl:attribute name="score" select="$current_score"/>
                        <xsl:attribute name="gap_score" select="$current_score + $gap_score"/>
                        <xsl:attribute name="source" select="$winners_sorted[1]/@name"/>
                        <xsl:attribute name="path"
                            select="string-join(($winners_sorted[1]/@path, $winners_sorted[1]/@name))"
                        />
                    </xsl:copy>
                </xsl:for-each>
            </xsl:variable>
            <xsl:next-iteration>
                <xsl:with-param name="ult" as="element(cell)+" select="$current"/>
                <xsl:with-param name="penult" as="element(cell)*" select="$ult"/>
                <!-- uncomment for cumulative output -->
                <!--<xsl:with-param name="cumulative" as="element(cell)+" select="$cumulative, $current"
                />-->
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>

    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- djb:create_alignment_table()                              -->
    <!-- generates alignment table                                 -->
    <!-- parameters:                                               -->
    <!--   $path as xs:string (d, l, and u steps)                  -->
    <!--   $left_tokens as xs:string+                              -->
    <!--   $top_tokens as xs:string+                               -->
    <!-- returns:                                                  -->
    <!--   html <table> with two rows                              -->
    <!-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:function name="djb:create_alignment_table" as="element(html:table)">
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="left_tokens_in" as="xs:string*"/>
        <xsl:param name="top_tokens_in" as="xs:string*"/>
        <!-- 
            break optimal path into individual steps of d, l, u
            traverse from the end
        -->
        <xsl:variable name="path_steps" as="xs:string+"
            select="
                reverse(for $c in string-to-codepoints($path)
                return
                    codepoints-to-string($c))"/>
        <xsl:iterate select="1 to count($path_steps)">
            <xsl:param name="left_tokens" as="xs:string*" select="reverse($left_tokens_in)"/>
            <xsl:param name="top_tokens" as="xs:string*" select="reverse($top_tokens_in)"/>
            <xsl:param name="left_cells" as="element(html:td)*" select="()"/>
            <xsl:param name="top_cells" as="element(html:td)*" select="()"/>
            <xsl:on-completion>
                <xsl:sequence>
                    <table xmlns="http://www.w3.org/1999/xhtml">
                        <tr>
                            <th>Left</th>
                            <xsl:sequence select="reverse($left_cells)"/>
                        </tr>
                        <tr>
                            <th>Top</th>
                            <xsl:sequence select="reverse($top_cells)"/>
                        </tr>
                    </table>
                </xsl:sequence>
            </xsl:on-completion>
            <xsl:variable name="current_direction" as="xs:string" select="$path_steps[current()]"/>
            <xsl:variable name="new_left_tokens" as="xs:string*"
                select="
                    if ($current_direction = ('d', 'u')) then
                        tail($left_tokens)
                    else
                        $left_tokens"/>
            <xsl:variable name="new_top_tokens" as="xs:string*"
                select="
                    if ($current_direction = ('d', 'l')) then
                        tail($top_tokens)
                    else
                        $top_tokens"/>
            <xsl:variable name="match_test" as="xs:integer?">
                <!-- to style cells according to whether they match -->
                <xsl:if test="$current_direction eq 'd'">
                    <xsl:choose>
                        <xsl:when test="head($left_tokens) = head($top_tokens)">
                            <xsl:sequence select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="-1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="new_left_cell" as="element(html:td)">
                <td xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:if test="$current_direction eq 'd'">
                        <xsl:attribute name="data-match" select="$match_test"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$current_direction = ('d', 'u')">
                            <xsl:sequence select="head($left_tokens)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="'&#xa0;'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </xsl:variable>
            <xsl:variable name="new_top_cell" as="element(html:td)">
                <td xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:if test="$current_direction eq 'd'">
                        <xsl:attribute name="data-match" select="$match_test"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$current_direction = ('d', 'l')">
                            <xsl:sequence select="head($top_tokens)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="'&#xa0;'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </xsl:variable>
            <xsl:next-iteration>
                <xsl:with-param name="left_tokens" as="xs:string*" select="$new_left_tokens"/>
                <xsl:with-param name="top_tokens" as="xs:string*" select="$new_top_tokens"/>
                <xsl:with-param name="left_cells" select="$left_cells, $new_left_cell"/>
                <xsl:with-param name="top_cells" select="$top_cells, $new_top_cell"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>

    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <!-- main                                                       -->
    <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
    <xsl:template name="xsl:initial-template">
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- choose input (for testing)                             -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!--<xsl:variable name="left" as="xs:string+" select="$woolf_us"/>
        <xsl:variable name="top" as="xs:string+" select="$woolf_uk"/>-->
        <!--<xsl:variable name="left" as="xs:string+" select="$darwin_1859_part"/>
        <xsl:variable name="top" as="xs:string+" select="$darwin_1872_part"/>-->
        <!--<xsl:variable name="left" as="xs:string+" select="$darwin_1859"/>
        <xsl:variable name="top" as="xs:string+" select="$darwin_1872"/>-->
        <xsl:variable name="left" as="xs:string" select="'kitten'"/>
        <xsl:variable name="top" as="xs:string" select="'itting'"/>

        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <!-- tokenize inputs and count                              -->
        <!-- -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* -->
        <xsl:variable name="tokenized_input" as="map(xs:string, item()+)"
            select="djb:tokenize_input($left, $top)"/>
        <xsl:variable name="top_tokens" as="xs:string+" select="$tokenized_input('top')"/>
        <xsl:variable name="top_len" as="xs:integer" select="count($top_tokens)"/>
        <xsl:variable name="left_tokens" as="xs:string+" select="$tokenized_input('left')"/>
        <xsl:variable name="left_len" as="xs:integer" select="count($left_tokens)"/>
        <xsl:variable name="input_type" as="xs:string" select="$tokenized_input('type')"/>
        <xsl:variable name="diag_count" as="xs:integer" select="$top_len + $left_len - 1"/>

        <!-- uncomment to generate full table; must also change djb:find_path() output to cumulative -->
        <!--<xsl:sequence
            select="djb:grid_to_html(djb:find_path($diag_count, $left_len, $top_len, $left_tokens, $top_tokens), $left_tokens, $top_tokens)"/>-->

        <xsl:variable name="final_path" as="element(html:table)+"
            select="
                djb:find_path($diag_count, $left_len, $top_len, $left_tokens, $top_tokens) =>
                djb:create_alignment_table($left_tokens, $top_tokens)"/>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Needleman Wunsch alignnment</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <style type="text/css">
                    td[data-match = "1"] {
                        background-color: palegreen;
                    }
                    td[data-match = "-1"] {
                        background-color: pink;
                    }</style>
            </head>
            <body>
                <h1>Needleman Wunsch alignment</h1>
                <h2>Input</h2>
                <ul>
                    <li>
                        <strong>Left: </strong>
                        <xsl:sequence select="$left"/>
                    </li>
                </ul>
                <ul>
                    <li>
                        <strong>Top: </strong>
                        <xsl:sequence select="$top"/>
                    </li>
                </ul>
                <h2>Alignment table</h2>
                <xsl:sequence select="$final_path"/>
            </body>
        </html>

    </xsl:template>

</xsl:stylesheet>
