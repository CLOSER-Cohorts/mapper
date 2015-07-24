PGDMP         /    
            s           mapper_development    9.4.2    9.4.2 W    K	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            L	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            M	           1262    16386    mapper_development    DATABASE     �   CREATE DATABASE mapper_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 "   DROP DATABASE mapper_development;
             mapper    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             williampoynter    false            N	           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  williampoynter    false    5            �            3079    12123    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            O	           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    189            �            1259    16397    instruments    TABLE     �   CREATE TABLE instruments (
    id integer NOT NULL,
    prefix character varying,
    port character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.instruments;
       public         mapper    false    5            �            1259    16395    instruments_id_seq    SEQUENCE     t   CREATE SEQUENCE instruments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.instruments_id_seq;
       public       mapper    false    5    174            P	           0    0    instruments_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE instruments_id_seq OWNED BY instruments.id;
            public       mapper    false    173            �            1259    16735    links    TABLE     �   CREATE TABLE links (
    id integer NOT NULL,
    topic_id integer,
    target_id integer,
    target_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.links;
       public         mapper    false    5            �            1259    16733    links_id_seq    SEQUENCE     n   CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.links_id_seq;
       public       mapper    false    188    5            Q	           0    0    links_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE links_id_seq OWNED BY links.id;
            public       mapper    false    187            �            1259    16466    maps    TABLE       CREATE TABLE maps (
    id integer NOT NULL,
    variable_id integer,
    mapable_id integer,
    mapable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    x integer,
    y integer
);
    DROP TABLE public.maps;
       public         mapper    false    5            �            1259    16464    maps_id_seq    SEQUENCE     m   CREATE SEQUENCE maps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.maps_id_seq;
       public       mapper    false    5    182            R	           0    0    maps_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE maps_id_seq OWNED BY maps.id;
            public       mapper    false    181            �            1259    16408 	   questions    TABLE     	  CREATE TABLE questions (
    id integer NOT NULL,
    qc character varying,
    literal character varying,
    instrument_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id integer
);
    DROP TABLE public.questions;
       public         mapper    false    5            �            1259    16406    questions_id_seq    SEQUENCE     r   CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.questions_id_seq;
       public       mapper    false    5    176            S	           0    0    questions_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE questions_id_seq OWNED BY questions.id;
            public       mapper    false    175            �            1259    16388    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         mapper    false    5            �            1259    16589 	   sequences    TABLE     	  CREATE TABLE sequences (
    id integer NOT NULL,
    name character varying,
    instrument_id integer,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "URN" character varying
);
    DROP TABLE public.sequences;
       public         mapper    false    5            �            1259    16587    sequences_id_seq    SEQUENCE     r   CREATE SEQUENCE sequences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.sequences_id_seq;
       public       mapper    false    186    5            T	           0    0    sequences_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE sequences_id_seq OWNED BY sequences.id;
            public       mapper    false    185            �            1259    16437    topics    TABLE     �   CREATE TABLE topics (
    id integer NOT NULL,
    name character varying,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.topics;
       public         mapper    false    5            �            1259    16435    topics_id_seq    SEQUENCE     o   CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.topics_id_seq;
       public       mapper    false    178    5            U	           0    0    topics_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE topics_id_seq OWNED BY topics.id;
            public       mapper    false    177            �            1259    16567    users    TABLE     �  CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.users;
       public         mapper    false    5            �            1259    16565    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       mapper    false    184    5            V	           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       mapper    false    183            �            1259    16449 	   variables    TABLE       CREATE TABLE variables (
    id integer NOT NULL,
    name character varying,
    label character varying,
    var_type character varying,
    instrument_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.variables;
       public         mapper    false    5            �            1259    16447    variables_id_seq    SEQUENCE     r   CREATE SEQUENCE variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.variables_id_seq;
       public       mapper    false    5    180            W	           0    0    variables_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE variables_id_seq OWNED BY variables.id;
            public       mapper    false    179            �           2604    16400    id    DEFAULT     b   ALTER TABLE ONLY instruments ALTER COLUMN id SET DEFAULT nextval('instruments_id_seq'::regclass);
 =   ALTER TABLE public.instruments ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    173    174    174            �           2604    16738    id    DEFAULT     V   ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);
 7   ALTER TABLE public.links ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    188    187    188            �           2604    16469    id    DEFAULT     T   ALTER TABLE ONLY maps ALTER COLUMN id SET DEFAULT nextval('maps_id_seq'::regclass);
 6   ALTER TABLE public.maps ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    182    181    182            �           2604    16411    id    DEFAULT     ^   ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);
 ;   ALTER TABLE public.questions ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    176    175    176            �           2604    16592    id    DEFAULT     ^   ALTER TABLE ONLY sequences ALTER COLUMN id SET DEFAULT nextval('sequences_id_seq'::regclass);
 ;   ALTER TABLE public.sequences ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    185    186    186            �           2604    16440    id    DEFAULT     X   ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);
 8   ALTER TABLE public.topics ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    178    177    178            �           2604    16570    id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    183    184    184            �           2604    16452    id    DEFAULT     ^   ALTER TABLE ONLY variables ALTER COLUMN id SET DEFAULT nextval('variables_id_seq'::regclass);
 ;   ALTER TABLE public.variables ALTER COLUMN id DROP DEFAULT;
       public       mapper    false    179    180    180            :	          0    16397    instruments 
   TABLE DATA               H   COPY instruments (id, prefix, port, created_at, updated_at) FROM stdin;
    public       mapper    false    174   �^       X	           0    0    instruments_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('instruments_id_seq', 4, true);
            public       mapper    false    173            H	          0    16735    links 
   TABLE DATA               V   COPY links (id, topic_id, target_id, target_type, created_at, updated_at) FROM stdin;
    public       mapper    false    188   b_       Y	           0    0    links_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('links_id_seq', 35, true);
            public       mapper    false    187            B	          0    16466    maps 
   TABLE DATA               `   COPY maps (id, variable_id, mapable_id, mapable_type, created_at, updated_at, x, y) FROM stdin;
    public       mapper    false    182   �a       Z	           0    0    maps_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('maps_id_seq', 2564, true);
            public       mapper    false    181            <	          0    16408 	   questions 
   TABLE DATA               _   COPY questions (id, qc, literal, instrument_id, created_at, updated_at, parent_id) FROM stdin;
    public       mapper    false    176   Xg       [	           0    0    questions_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('questions_id_seq', 493, true);
            public       mapper    false    175            8	          0    16388    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       mapper    false    172          F	          0    16589 	   sequences 
   TABLE DATA               _   COPY sequences (id, name, instrument_id, parent_id, created_at, updated_at, "URN") FROM stdin;
    public       mapper    false    186   �       \	           0    0    sequences_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('sequences_id_seq', 10, true);
            public       mapper    false    185            >	          0    16437    topics 
   TABLE DATA               F   COPY topics (id, name, parent_id, created_at, updated_at) FROM stdin;
    public       mapper    false    178   a�       ]	           0    0    topics_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('topics_id_seq', 113, true);
            public       mapper    false    177            D	          0    16567    users 
   TABLE DATA               �   COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at) FROM stdin;
    public       mapper    false    184   �       ^	           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 1, true);
            public       mapper    false    183            @	          0    16449 	   variables 
   TABLE DATA               ^   COPY variables (id, name, label, var_type, instrument_id, created_at, updated_at) FROM stdin;
    public       mapper    false    180   ��       _	           0    0    variables_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('variables_id_seq', 526, true);
            public       mapper    false    179            �           2606    16405    instruments_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY instruments
    ADD CONSTRAINT instruments_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.instruments DROP CONSTRAINT instruments_pkey;
       public         mapper    false    174    174            �           2606    16743 
   links_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.links DROP CONSTRAINT links_pkey;
       public         mapper    false    188    188            �           2606    16474 	   maps_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY maps
    ADD CONSTRAINT maps_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.maps DROP CONSTRAINT maps_pkey;
       public         mapper    false    182    182            �           2606    16416    questions_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_pkey;
       public         mapper    false    176    176            �           2606    16597    sequences_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY sequences
    ADD CONSTRAINT sequences_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sequences DROP CONSTRAINT sequences_pkey;
       public         mapper    false    186    186            �           2606    16445    topics_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.topics DROP CONSTRAINT topics_pkey;
       public         mapper    false    178    178            �           2606    16578 
   users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         mapper    false    184    184            �           2606    16457    variables_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.variables DROP CONSTRAINT variables_pkey;
       public         mapper    false    180    180            �           1259    16745 (   index_links_on_target_type_and_target_id    INDEX     e   CREATE INDEX index_links_on_target_type_and_target_id ON links USING btree (target_type, target_id);
 <   DROP INDEX public.index_links_on_target_type_and_target_id;
       public         mapper    false    188    188            �           1259    16744    index_links_on_topic_id    INDEX     F   CREATE INDEX index_links_on_topic_id ON links USING btree (topic_id);
 +   DROP INDEX public.index_links_on_topic_id;
       public         mapper    false    188            �           1259    16476 )   index_maps_on_mapable_type_and_mapable_id    INDEX     g   CREATE INDEX index_maps_on_mapable_type_and_mapable_id ON maps USING btree (mapable_type, mapable_id);
 =   DROP INDEX public.index_maps_on_mapable_type_and_mapable_id;
       public         mapper    false    182    182            �           1259    16475    index_maps_on_variable_id    INDEX     J   CREATE INDEX index_maps_on_variable_id ON maps USING btree (variable_id);
 -   DROP INDEX public.index_maps_on_variable_id;
       public         mapper    false    182            �           1259    16417     index_questions_on_instrument_id    INDEX     X   CREATE INDEX index_questions_on_instrument_id ON questions USING btree (instrument_id);
 4   DROP INDEX public.index_questions_on_instrument_id;
       public         mapper    false    176            �           1259    16730    index_questions_on_parent_id    INDEX     P   CREATE INDEX index_questions_on_parent_id ON questions USING btree (parent_id);
 0   DROP INDEX public.index_questions_on_parent_id;
       public         mapper    false    176            �           1259    16584 '   index_questions_on_qc_and_instrument_id    INDEX     j   CREATE UNIQUE INDEX index_questions_on_qc_and_instrument_id ON questions USING btree (qc, instrument_id);
 ;   DROP INDEX public.index_questions_on_qc_and_instrument_id;
       public         mapper    false    176    176            �           1259    16731    index_sequences_on_URN    INDEX     O   CREATE UNIQUE INDEX "index_sequences_on_URN" ON sequences USING btree ("URN");
 ,   DROP INDEX public."index_sequences_on_URN";
       public         mapper    false    186            �           1259    16598     index_sequences_on_instrument_id    INDEX     X   CREATE INDEX index_sequences_on_instrument_id ON sequences USING btree (instrument_id);
 4   DROP INDEX public.index_sequences_on_instrument_id;
       public         mapper    false    186            �           1259    16606 )   index_sequences_on_name_and_instrument_id    INDEX     n   CREATE UNIQUE INDEX index_sequences_on_name_and_instrument_id ON sequences USING btree (name, instrument_id);
 =   DROP INDEX public.index_sequences_on_name_and_instrument_id;
       public         mapper    false    186    186            �           1259    16599    index_sequences_on_parent_id    INDEX     P   CREATE INDEX index_sequences_on_parent_id ON sequences USING btree (parent_id);
 0   DROP INDEX public.index_sequences_on_parent_id;
       public         mapper    false    186            �           1259    16446    index_topics_on_parent_id    INDEX     J   CREATE INDEX index_topics_on_parent_id ON topics USING btree (parent_id);
 -   DROP INDEX public.index_topics_on_parent_id;
       public         mapper    false    178            �           1259    16579    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         mapper    false    184            �           1259    16580 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         mapper    false    184            �           1259    16458     index_variables_on_instrument_id    INDEX     X   CREATE INDEX index_variables_on_instrument_id ON variables USING btree (instrument_id);
 4   DROP INDEX public.index_variables_on_instrument_id;
       public         mapper    false    180            �           1259    16605 )   index_variables_on_name_and_instrument_id    INDEX     n   CREATE UNIQUE INDEX index_variables_on_name_and_instrument_id ON variables USING btree (name, instrument_id);
 =   DROP INDEX public.index_variables_on_name_and_instrument_id;
       public         mapper    false    180    180            �           1259    16394    unique_schema_migrations    INDEX     Y   CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);
 ,   DROP INDEX public.unique_schema_migrations;
       public         mapper    false    172            �           2606    16459    fk_rails_1d0ee2785c    FK CONSTRAINT     z   ALTER TABLE ONLY variables
    ADD CONSTRAINT fk_rails_1d0ee2785c FOREIGN KEY (instrument_id) REFERENCES instruments(id);
 G   ALTER TABLE ONLY public.variables DROP CONSTRAINT fk_rails_1d0ee2785c;
       public       mapper    false    174    2215    180            �           2606    16746    fk_rails_9e38e93f70    FK CONSTRAINT     l   ALTER TABLE ONLY links
    ADD CONSTRAINT fk_rails_9e38e93f70 FOREIGN KEY (topic_id) REFERENCES topics(id);
 C   ALTER TABLE ONLY public.links DROP CONSTRAINT fk_rails_9e38e93f70;
       public       mapper    false    188    2223    178            �           2606    16600    fk_rails_ba0e571bd5    FK CONSTRAINT     z   ALTER TABLE ONLY sequences
    ADD CONSTRAINT fk_rails_ba0e571bd5 FOREIGN KEY (instrument_id) REFERENCES instruments(id);
 G   ALTER TABLE ONLY public.sequences DROP CONSTRAINT fk_rails_ba0e571bd5;
       public       mapper    false    174    186    2215            �           2606    16477    fk_rails_ce690a0b27    FK CONSTRAINT     q   ALTER TABLE ONLY maps
    ADD CONSTRAINT fk_rails_ce690a0b27 FOREIGN KEY (variable_id) REFERENCES variables(id);
 B   ALTER TABLE ONLY public.maps DROP CONSTRAINT fk_rails_ce690a0b27;
       public       mapper    false    180    2227    182            �           2606    16418    fk_rails_d757080e7f    FK CONSTRAINT     z   ALTER TABLE ONLY questions
    ADD CONSTRAINT fk_rails_d757080e7f FOREIGN KEY (instrument_id) REFERENCES instruments(id);
 G   ALTER TABLE ONLY public.questions DROP CONSTRAINT fk_rails_d757080e7f;
       public       mapper    false    176    174    2215            :	   �   x�}�K
�  ׾S�����z�B0��Bm��@��3Cfk�"FR���N�Rfu"���i��Q೦�ا� ��W]��<���!��9crB<�� �<�V�h^������2a��g��%&����hK:N      H	     x�}�K��0�תS�FԻ$�"��fz1&�1�O��Ƕ����/>��W��P���������Vɞ1�Y���aZM���Ŋ�(���Ʊ�`K�. �D>H��yD�. �� 6�2��L��P�X����M"!���&$W�Ufh	i+����ڙ�����@OF�2�@�H1�Hļ6��q��9�r��q�B���f�(
�"j��������o�h�UB	?V���R���YA�nz�h/A�s�)(�M5��2�I��(�/@&�P��0�A�SP�����h�����4�r� �A���S m��a�3ќ�X�^�l�.8�7����M�U<H8�	�z�h�U�&�	����2:F��-$�K|��9_�+�_�=0S+fp�x�Հ�N�$�� M�h�ۣ�婧�$�F�S'f�d�-��B�\c��d��D��$.-/�O-m2k���:��@��!��Z����ONk~/�h��ק���/_�������-�i][H ۧ+��G�����������$��
  }ߓ      B	   �  x���=�]'��7��44�Z���+u�Dl���#��U�t��ޅ�&�_Q�[|���_�����߯b�ڷ����{�s��A�r�~���G�5A,/)�#��/��^}��I��&)1Cl/���1r�IJ,�+�ث�r��X!���~�")��b�G%�Y�;���)݉%���MR‘ :�X��p���� �"��εޒqL��G����qKJ�1�>��%�r�̖��gr��=�Hɨ̒��gh���C�%w�2KR"��xFϔ��W�-)�d<#^�K�֨��D<�:�ūL�sU�HJ�3ψ���B+ƨ��D<S��x�nM��R�<V�>��ޖ.���$%��3g��}k��DSpL��q�&�7.I�8����J�!Ev���DSpLu�}�s���DS�b��p̖��c�x@d)0��-)����8R0�qIJ�1��(�&�IJ�1��O�<v�-��ϐS{ƨ��D<�'6$�2KR"�!�����(��D<CNy@li�}�%%�:=��Id'�HJ�3䔹݉=$cyܒ�9e�6�dc�zIJ�3��8"!�&)ϐS�z��<CJqy��u��&�2{�b*�l�(�Pc�'���&)��Q��#lI���O̴��[R"~�L>��m�▔�_ZBl�X��D�BF��i�U��ʶ�D�m�qഛ�D�BJ�T#�lI�8���{�F��қqa��O�^$%�h>q�ԟw�-)ϐ)�A�J�!�����D<C���1{�V�ؒ�����C�g�1[R"�!S���g0�qKJ�3d
)�<�6��ER"�a)��d���k�%%��K��G�F�$%�2�T'��\F3�gIob�3d
�^��� .I�x�L�ح��-)��>�J7��-)ϐ)|b�f����TgO�8g�Β��cX�|"���ʖ�8��{�Ơ��į�}@D����97�1�G������9yBlV7n�M��S�1�mΡg)ʛM�8�F#�7Q[R���Ks֝1'ܘ�%)q�~i�_e\YoI��)Ӽ�a��;[R�t>�i^]�t�w��Df�L!̼ͫ�5zgIJd$d
�^}��Q�%)ǐ)�{��b��[R"��ݥ;{���=�&��ǐ)X�"ѸWߒ��B�WkrM0F�$%2�8���պ�!Fe��D:�L��7j�*߸$%27d���ݓ>C�xϣ�y�L����ת��b����/��-��ԏ�VI�x�L��u�k��PTR"�!SpPt��8qIJ�3d�����k8�����&<C���5���/G*)��Q�|Ϸ��EĨ����gҼ�F�	��D���L��[W_�Z)V��������(o�T���JJ�gӼۺ���k#o�UR"Փy�u]�y��P��Y�q?��dx�3���$%���]bkɘ�%)�~��q0���7�SV��	��c�RI�� �O����S%%☜c�\�%%�c�<!�y�t��������7�s      <	      x��\�oG�����G3�G�p�;k�X+��w�Fs�"g=�af�����k��-�{8l>đ]TWuu���� g�埼ٯj�����릭+'�w�RwE�q�m�:wu��k5�f��E�nr�������?x��uc/����0BF�'ŬT�v�z��E�o��+�CW o }_7�/�������ȷ�ܻp@�u*��Y�";	d�Y�����O;��鶸~1ʡʅ:P�v6�M����8o�v_t�Ï�jl�$I`'�4	J�~>��S�砺BW�ye?���F
a�Wg7�ؿ�Ρ=���R���_�u�k3�  Im$�!�hv-�:9��Z��.A�^;sPwK��:9薎;\8�M�i�H�ÅEؗ�̘�D.��n�-
��y�0p]�&���z�l2�P���Uw���\.��-������>��[8^�)�4��P
�Hgכ��8�j;6�bA�M�4���0Hm�X�*����"��j���Nu�ּv�'���k3渳W���Ȥ)Ԇ�6��\�ڛ���^��G���ĩ�Y(( a��}*f�h�`�x\�C��Å{R���[WW�u���[�2�L�$3���k�s}۷���v6�u��(�2�j����N�v��\) ����������^_�EH�4m$"� }��51����sW7Z<Oka��&,%
��FV#�� k) �kPA�:s��,ѧ靪`���kN�U�F_nAAWˢ(��@��p��������^=}Y=���2#t��+8T<����|[ץ��:�.�bw��?^����~T`ֽ�&&�	��Y��k� �/��jA�;��n�@�\�e�X�ׇ\�i]x~�6
A��ӻM,���uE����Wҳ��%A|d�����$�,ʓ��~;��P�HQ��$���R���e
��0����1>�|�l�{�WGg�ȥC�o��ß��t� ���'%CD�����b�A���[���}�;A� ��y�,M���b�25���8�/�2�1		�cL��H�����T�2�

u_7�I)�l���W�>n�"�Ԡ"&��H�-Ln�*�#ǽ�=	a9��cõd�J��Æ��PtV@*��q�-���z[�?U^֨�G=��hb�8�@�ø�mA�����7��ɲ^o�&ﷵө�$J(�U	G����(�<^\9^D�D�YC�g�H��ԇ���w����`�^-fm�nb�DAm����uh�zHQ#�Ã�1��#�e>nb���_ ��k�x|�|.:���CUbN*[c�! �����D�,�ǐP�H( �f?C<���~wy]&u�z���2Q�0�
%�xS�*?>�mh���g@u&��[��"6�� F�����:�ߠH���V��f_���C3�Y�!���a�tk5IM.�I(*�������Q�!�������f�)���d�������e��IȒXv�+�(���������bJ���`�ڮ� �˕��f���	&�X�|�T�>��{4�b*�q/X+ż;]���n�z͢�	+e �pJ�����VJH^ͧ���B�T�o�χ�r�hGmR��S�t�Ѐs��	��g����%�"���ߍ|g�&�C�m��;K]��j���E�ePnۂv���1��Hv|ϙ���0�x��v�>�q���,�{dN���ʙ�&�Ӷ�.��R}� �R=tly�ۚC���D}]�U�r/�I�`����"'���	N�פ�LG���f�f�_a�F+0�3�E��o��p�
���|/6������,�(��C��ҐXUݱXf�F�ݓ���'�L~��?S5����a�N^l�� ��9`�v<�oj;��|�N��}�b���;~=�V@&���')�>e�}?�b�b*"dEp)�W����� _�Vx 7v���`��탴N�Jt�p=.Ѣ�N\��٩���&�C�.$�M4��_};Ib(9
	��U�p���ׁ�,0�R@�4p/@�I��+�\*�����tA��0	v2m�u���e�,�r�Wc*S�P��1h
֦��3��iՔ�}�Ų�~x�����!��J��e�QB;!�^�eG�>��Է����MC������>�6
a��xI��M} ���rE��c8	-��Ir�h"$���wLa(�-l�h`�O�z������O�3Bn;TL�?R� ������s�w��,�(��V+��`�5�Gω#)�� `�e{I�f��$���<�v��\���ȋ�,T#��[��>�	�݁i(�M!��뼸3����M3�♄��d���X*k��TuڔE��c�S�~}�:��+�'�1i���8���p�L�}��}M�~�=��^��f�k�K&!/���\l�r��u��$�����j-�_��z��\�
@,��9p�$5�d*��"�_�`��{���ET�8[�����&�s`��#�:X0
��PTK8���Nͬ��M"C_EHȑ�C:{��V�6�7ػ2�����13��R˥�U�J�R�5��|�E�T��>�B�8�ulM���|C?]H(�v6{=�E`���>���y�7͋�R�a�0�˲*k��)H��wJ�?Z��b��X�� ����h�Ͳ.�\��-��0�ϗ��|��72�#��k��ɭ/��<n�}{�4�,��!�R�#����}�v��>��`Z;pl����m�I�3���ϔ���4�<^��I��}_�x<�k�i	��z�}+���Dg�!�����~��Ma�8�:
�
=74\S&�Q��Z5��D��Gb=DƓ+�?n�Z�#C�XH((��K��N��N9���͗)�dmf���Y��)v<�U�:�
�(NW^�2�#�a0	Y���\Y�$Wt,�3� �MQ���s"�W�U�Ä��V8Ų�)���q���I�&69�ABT��^����M����l��>��K��w`�w�ٳ�,�qd@&�����S0eUJ��!\a���j���3���Uv�Fc,r5q����N���r'��&%����:�0�����rTjWUz�b~�|����� j{���,Z����a$HH(_��O0	�l��}�E�0�I�"�׮�0��x�m��{2��ᚴΊCP�T5����P�~�k	�-�f<73L�
	`�	�CǺ�Ĕ���Q���0� q�r�E�/h���LJQ�֕�˦5,�Q�E�84Ԭ���3XѰ��gvJL�n��	��s�
D�SyG��ڹ���ќP�������B���8;g��f��w�]:�UW��5V�^�0B?�C�DB!�8�aײޔ�
c��Q4s�(�O�`%�� �B�|�Ȉ�sK�8�&+�+�oϸXA�Fʄ�\���Ȗ���N!!/���?�d�����n�ᴗ�O>���/L�n��D�`�I(Q�K���WX�T�-bEa�YI(V8���nt�L�k��$X��!�`���#���N�wjUaU�,���%EYV�t�_�W�D��պ�f�5���*�����}5��=���#�s��C������*$�5c� �|U���BМ��|A�,�^j�-��K2p��Fc�k]������� 5LBV��*�}8 �凲nA�s�}P�ŋX�^�>��e6�\cm�<����el�̐�	���F�����٪�����{>4��^w��VR�/���!�e��\��� 0l�I����^߼q��v7������8G.�Ul$�L93kz��*�b^t�����	��'L��O
���窾�^�҃x�JB���r3{h��l��z_7�^/a���	��`��ݴ�|[�����r�o~�	�a��E�5��[((�D���W�b4�/�i_�_?�̈��F,���݇7�o���������_�w��B����?_�����:�K�"����$$���)�ftj��p�D�^���}u �`��GV���I{�Vbv�w'^QZ:�p�w�T�.�I=�+�Ü���j���	�U�<��{K��k�QBE���(�S�w�����Ö���$��,��As8��{ �  =�cr�C6j��Q���BB��3:�sGw�0DG��ל�`P�I���F�,�ӅQ����V3	Ed�����QǄ��	pգ��׌�"���Aaj���,J�bS"$$��@t��N�ah�Tb�C������-���,Z��0&(�dYf��
hVr*&r�3�X��j��Ѣ�ďM��IȟB�ɼyY-v=�q����8{�%If��		��=� �5��7H�af@J&������F�����n�(m���腣¸v_C�P��ЖG�
gzW���x��n �Pr~��S:����!�݁�*U�8�9IC
LM���b�Y��p!�0�pB.!|۰i��F8=p��sc�u�����jP��G4F6��!!S�A�؍"C�XH��&+�C�!��}е�Ş�*qBB�~�u̙X��$�����Sp�`\��X[#�����l���P�*��ӟ��i����y��Ĩ>���?��b�H}2��g��ቴ��82�X����"2V�/�u���Lk��p7�����ʙbq�_L==�1�g6rc�C�q��2���8�Ø���?#�Q�,��)r�� ���c�d���8DLp�G�0O
#2R��L״�)!���BB��R���*�Q)�c��:�������5��CY��顐@~�������\=Iϸ���{��/��ruc}��9��{� _v����$�*f��d�	�b�Ɔ�UHȚ�0����xA) �
+E�rr�c��9���r*I�*�BBI�����a#c,�+`M�����0o"5��r.��|���ԋ�D�q��3���fF�0qZ�9~�G�
5�/��k(����z0�"JA_;g�����{�e�Vf����2!���n�9�5��ċHȋ�4�o](����ky�H��)���3�xAqL�kT��������S����|#�c�����ƽ$��J!B½d�^��6s]��t�'��$q�����`�,��
���c��ig�@�n�!e������+.� ��f�K|�4U"$\�⮏<Ѯ�����n�%,��k�'��W���fw��0Eyʔ���3��)ȑpB�>	�p�ѿ����m^t�Мp\ZI�F�O��Fl���s��4���|�L�n�|����t�L��7��4�kX@��g�1�pˌ��b��Ѧ{�qn�2�XAx[���(8�3�o;?�i�+��iX�d�xv����!iT����/2|��p{q������,=�fI2<�Ꟗ�w.�o	�YC��=k�)�?�i���[Ď��0�"$;����;ũj	�f'����!����V�$�8�q����Đ2
	��W��<d{���RO��Op�Ap��߽�ߝ˻#�X�q
!�X� A�Y&��!�k~�3���2Xx&�!Fg
r��������!�0�w	�"����#K#�0�"$\1����uhT��iK�dnfx�*$\��ҸW��	���^(yI��gdK��&�i!y.p&(���O�j�Q�Buۧ)S7�Q���G�<�[-�5�3��m�ބ	��"��ǙHd�'�9�Tm5��K"#"��8�aۛ埗әy~% tOV:�K[�7�P������<C�UH(?�<����4z�gp9u��7̀�e�ݼ@`p��uWB�C���/�yBGf�-M��ER!�lD�l
�W�o�NO�%o2�O��� L��B�CSl�Ng{#��������0�&|Z��Tn\NMs�U+~0�9�C�"��������(�rL�'�*��������I�o�}��n�D�g�N��>/!�j6'� �n�fߏ�[w'�;94�v�3`����5�5w
\�.I;��T�Z�8/��Ҥ�0¯���@]~��w� ��4Y      8	   b   x�U��C!�;�T��Iإ��Q��=Dʓ�4�4J�����bL�KZ���(���&#qRs-}S@��.'�;Mi݂�a�WyI�"���Z��(+      F	   �  x�}��n�0���)
�&�uG������Tʆ��Dl���<~M%,2fc���|���8�j�udb�6��Φp��C׏]B ��8z��K���M�U�����y���5�E�T��&/��D �]�0��4�pjz2������M��%�OH�6iN
Px%�p��Ȕ�R(Hܩ��mT�/��!C⇷w����f���K8]�z��4�Q|�}�٦��m��J.�o���M��k(�a�=���F8n�����
�=��A�'ϊƃ�.�jU?@Q6�e��/Z�X�)��צ.kZ����\i	c$e-A�wj��:�d������rѱ���+�:w�h�Ƞ��3e�~-�H}��G�9�`R����c��+r���=1�^�>|J�Qm+�N=��ژ�o`#�~�)��+)��=�Z3�q�iB1�#z*�b�
��.%5�j��ג����h�      >	   v  x����rܸ��8O�]<U����)��ʲkR�̆bC݈H�ŋƪ����n��l�k�p�`�\�C�|=��>3Ʌ~���3a.��T�B��h���)3�/�⒋ataH�!̣��Y���&�U�����k]7e�~�?�_^^��*���K�/����7(���4�������@KYc�����ZNBi���K?�ڍ�Iu�mI�'�}Xd�jp����&`�"w�P=�0x�/�m������*��6X��j}��P{�~����@�^q�	Մ�`׻��&:Z$�Ro (�u�7�)�R\���к�՟~�]7�F�Ta5a��@pv��w���<�Ϊi�ӼsczÝk���WWk?���ei�!�ۃov��=�&�qO��5Fl �}B��P��h�i-J�z	�P�K�Sf���
[a���}m��e�>�����//��(�z��쟮۹�P(/�r��z:t���C�{RG�b��ӭ��\�ݫ�l�Ã�(5�KSl ��}C����4�f��O�9�(���-��Y����)isb+	�4�����C;R�a��@Z��Pa �蚆��C&J/���$��K͉��{��1�W� d����b�lÝo��Dii��|���m5�|x��zn�!��ɵL�?e�U�`B����T\���(j�S���q˽�)O���/I�B/���(�\	�)��{�{�ѝS*
M�)!P��{{����U()�u%ʠ��B=����0G�-�b�������O�#�Y*a��%����n�:{��b��$�\} %�ℇ$�d_������FjMM�΅ȷ��>�.���U�|ed��Т�5a�D��\��� ����۪�Q4�yJS��vA.1z���@�����V�BH`�/��%�����i�`�>���d��\��`{��m<�������ܰ��N�r|n��;ޑ��Rn!�üj7�D0W�� ������-���+E�� ���n:��Ú�|y�+��@�Y�>TCUOn��jrqZ�%�ń@����K[����3%'\,!���/7�n��J)<!��8nax������T�$:g_��Х��4�k{\d�	Q+
N�5!����i�\</J�XYB��s݆�`%R�|H8FB�-&�=���G+�jF�tq!G,���l��s���X�~�{=!�%v��D{V�֏i #�p�"�&!0�}�E�yY������7n��M�GA�qA`0�2]�����^}L>���j��F�;lBc�pl1��^���e���i�ɖ��-�j=�/�~�U�$�&QbE��Ђ�v�8�SR�XMB`,�m�CBJ�jA�!!@׽j�p�W���:썈�aA`J�k�>��aޏ��.�-��o~|Ȧjk{�(qB	�so�z�~/�B���s�/+٭�>�-�����M��bD�i-��aA�cSH�o��kqf[��z
;f�~	�������O�4���Q�h �/�Z��aJ8��9�P�vu?!�y��Q�#%��]����k5��=����0mB`��6*]Y"E�7��J�w��o	�<'N%!(�]�#ǹO� �R����?9G�c����x��9e���P�_/��Tf�+�X�O���և�h�uɱ�\Ol2��C,P�;޹bK�����Է�(����K�m�S�]w�Aa�?*�0�����:0�jV/O
�컹��o��TB���'��㶰#�Gc�ntJP�U^����͘J�(n��-J���e���s$��An��U�I���T�3����z�R��jBP�?sݾڧ^��D�`Y:}oȪ��j#2��T�X�&ݤ7��yvRLsR,"(-�R�s͗��ؔ.
��.��Ϲ�n�q�t��� (��Y>��%Qx�9{�����*��%���v5�n"%p0*��JDO?5{��XQ�/|)U-��OUN���%R��Z��H��n��'�ID�*K≓J���#Dj>C]����'Z�k7�'���恐Q��zݗq�z��+޵�ƍS��5HU��]B�Ĭ� ҵ�X�"/s"�/Uʨ�-�$�e8~�Z؍���錘�$��P,ΪSu�m%�%t��d׽ߟ��<я,��݇0�m��%N;!�� ��_j      D	   �   x�3�,�+ȯ�+I-r��O�KL�+��T1JT14P�K	
��ɵp2K�*�*6�(�L4
�s�4�
�	��17��O��J�w*�
t�	��"CN#CS]3]C#+S+cc=scCK|RVV�`�U����1.�F\1z\\\ G�2�      @	      x����v�8���ū��tf�8��s�-;v�Y'��=�Y�;�$��"�I*n���
��$A�O&�~���B� �q���D�"8��������W��\/>��V��p�<	��P�a�:�_�*��rB��X,�nnOo�Y|�Wu�*�|�M��o:��[B�lJB.�?�/����.�*��~���׼yt�G"�'$��,�>~�ǻo����k����ս���wDs�8�&$�����oP~��pZuy�;]�+ݸ0"��0jq������{�2��?/t��e���ʺ^��M޶{7)�25!��-�N�}~vM ��J�Ql�[�Oq4!y�������T,_���r�-�}Sh_Wk�bU���-�$�(K'$��ſ?������O�ѿ�(�\�8��Pp�8=����U�o���?.�.�b���5�}��գ��s���?�?�~Q��?���T8�����@���@&h�dBT�pv�1��y��lF"��2X\�h6�2�M�"+Y�+K '9�M>]uh�홃�FQf��z:��l:�Y�ϫ?]3(M��bMY]t9��6�����\����U�S�Gf��	����5��nfL5�D��,y��_���tySa-��ֺD��@
~B8�5�'�r�Z׼�D�,�%���]6���䍋�djY�X9^����87س2�״�-FK�2�a���,'"
"aY�.,�yt��Kb������EK��w����]�uޅ��0�i���� %{��>�ؑx��������+:࿸��w�3���$�,�?]�\|�]�S�׼��UG-|�4�[+�������O���5J��Ej���[�d�)Z�C�]�TZc#�zL�c�lʺ��K�s^�k��@D�H,-�Y��zęn�E�ot�������m$/L���/�2o��a1�Her|�0��rE_�{��k,L��bEM����Ϣ�]#)��Kl$��%{��N7(�3<�$�e8�H�C�r�ɫU�&�6�H�Q��3H�'�=�n���o��)J-��
�}��/��ܵ:DBŶ�
N����`���dD;1��b�|�^^ܾ�fG0���[��+W��,���V�2�)�k�S����{Ŏ� ������g���9����^>�/>��!��$���0�����T3b����1(!Q�Q��z���MI�I�o��JD1J��ך\�։��YŒG�&0r��������ڗ>�&����/���;]9�JR�hf	?@�H���X}�_�������z��(,��%�$��q޾�m�JoaW�m��0��H*!�E]�U�*0T��L���0)a��uM������M���#0�Gƃfp0�b�ǯ+�E[�l�,2�e	�l����7d�2Z����������ֱ��� �L1#y��,�8�����ۘ���6��E8��YA���v(��ز���S�
��!e$����/��>�u7����D�������ه}�7�G�>���C^�� ���y��׎�ᢅ�k������o>��]pĮ"�缸�8�8�Ra��P�\ܞb�7�>�+�[���*��f��kSC�wZ�ŭ^���D�:Fqfq%���,� ;#ZC?��m�W7��0���ؘqK�@�z[j�@颒؝�41U4�H	�i��֏/�M{�u�=h�p�p	4�����٫�[��Ԗ��tK��
88Q λ
�w�<�Yvy^�)���á�.Z�Ė)ƒf���n�UQ�P���+����;;Tv�o�4r^����GG���"ba�	��Q���5���+�T�S�!����~���%QE��x'$Pb�a���֨�~KS�]m^����o��U�c��6xP�|d#(h�P�����(}������P�w�꺜ߠ2�/;!�,�,��'W𞚗�Xܪ^���Id�	��	�͌l�;m�l��|$�� ��/���z��PǢ{��ǀ3�c�
�lz2n���
~����KX���!�p��\�bJ�l�$��(�Q���>����!.V�Ɩ���EA@��;։�zŴ� E��LH���6���0C\0+�`	��, u��.��륁a�h8���'�N�+*���%������z��9X:��a���Y,�I�G�R|�pd��n��Q}������׻]�8��4���,�GVGPo~�s=l�զ_:��i���y7XdgBb]���%�Gw��u�ҟ~S׎�ddY��Y�����C�
f���Z�����A�����K	<E+ar��<�'J��Ėc�b(�H��[n#��÷ykb+�jE�&|4��a"���g$��qޜ߼;_T�u��ޢ|, w��;&��v��DRzD$������(	hJ�kح��r
w����] ������Q�:L^�i"����($����a�a��W2�j�t���hW�c�[viF�L`������(�\GZ�K@��سۚ̇:����EpATj1tF�]@�7qDI�#g$ Ȯ�W]���,0�-.��P �����L6�s�=�	E���k���ڔk�N�^��vrk$��x����O�haM��G���(`�wM��&���#�1!GF,T�>���f�U��,{\#�xr����#7���|[ߗ�Ҭ��δ��eY����h�,9�dE�j��Eف���t�C��#�2������ꚛ0X�i�hd"e�E�o1��a�I"��A��#[e���v�h,1~��u��Y�S�%�e$�x��6��&gg�T�k�_�\���<�Kx�u �6��U��`ʜ�_�Jeɻ2 d&b�U�V��)ڮqFE�E��`	E�E���xWmt������Ό'�Dۉ��@ฌ�}����wC���d\QIf��,C�@rE��ߖ&���oO]�wh��;.2��k$����,փ�f�v��W+�T�Df[6Y�� a��B�?��w
M*��_�)��'$��
��[����р��M�0�c����r��hd��+F���Q�$�`"���F�����,aŦP�]��BH����b�}����ζ�}rSCL�ḕ3`0��]jT��ݟ>���-ʼ
�ud�}ɣ欒$8�+�4��_���Іa~�b}���F��0���)��y��=�z㇯cFf�tc#y�5#L4����8l��%��	O`b7&V�ʐ�E�74����kQc(b�$��-�
��b�0V2Ne0nA�o'�D���\J2�fؿ�_��\�Y��+�Ee��ѺV���A�J��r�S�*������'M$����@�ͅbϟ��,��'.��Ԕ��[Q��bF�U�ݕ�J��v0�_�y�H|��>є;��)�	Jq(�jJ�).��0�\Jh�{�O������E[�o�0�7�(!ʦ$���T<��ۢ�:jU&A���`���`â���O(��L�:�NI��O�kc�ɀ1�bHy��:�N��0L�� ���	�#�p��z�������v��@I�@$�A�4}	� oI�N<�I���I�))���.��kV]�X����H7���]A�FZ���w�߸F؛�]�4H-�%�$����i@?��:o�����A���z�Rb��aZ��%p�d�7�v�W]KnNs�B=�9�$����Ӯ���׾����h�몁�b��g�RRLI �!�}�W_4�S��3����P|f��������$I�xB�'>|��\���V�dJB�)^��?�RH5%�s���MQiڅUwp<h�wD]���&$`b��Ӝ9uJ�0��`<��Λ���GT���,M�z��9�=bei(�@ํ=ʿ�m�GO�}*��2�YB�)]�?��6)H��k�8/t�l꣚_a1%�x3��/NT��%�<Xs�$�K
X�X3�� 
-��fj'ڊ�S�LD6+�8fv���y�{<�
���mLB�fF��ǲg����!�� 0�X-�5��CIO�`<>����TVz��9u�D���� 1�9[�K7Ūns�k^TG��4�3�		3�3=�UE���H<��m}W�
�J����`ɣ|xhaN=�Z6I^�x~cW|���<�ׁ��    c��RA-��,y��d���̩SK1�0	0����n6����#��\�ţkoL��9ua�,3�%�x�c_�!_}9�B>o��$�/M���U�ٚ�%Px��@����Oώ��D+X�=K(?5�k`N-d��j�(<����lr]bg������aDϩO<ߑ�<
*)\����)v�q�a����?�xQ�S;mi����MP���&׭+ؐ&�-4!���>�-����l��ştǨm��l7u����0+ږ���F�'#�j�O[`�|r6X�)B�
�HJ�K��� ����/��ܧ{xu�o����ߡ'�+Rz6 ��H�gc"������Ԡ��1��tZj'$���0I��ʫ���a/�����-�[���E�a�͗A�����P�`��8�9�h��6����+,�x��p��2;]���RPgJB�<��[�/:4�o&�����&�T���z;H^��W�Y����v�����uS:|�������y����?�闵kH����$��i���h�����������9���)��J�	�c���V�+��O3J\�K�p���޶k����s^��\G��<H(�'+|��(퓮��;_����[�i8?$�35�g�c��)Hw_sf��|5yBQY mM�(<C�5�<�S�5/l0�w������6MY���C���B�߾j\=S]�K(�g)|��i��_��j��a�|�t�8M��(u+ɋC��p��xO��c�q�����˦�r��眧1	,��t)iST_���Ú�,B�+q��P����/u�mG)]P�z�2(V��s�D0�$/�x>���r�$��e��G��z��u?���}U�y�0�Qg�!�A�'	�������(G����#���t��llP��H �|�;�{U�l)z���ݲ�[���k��8H�EZf��@�Y���B�s^��?��{���Nrt�<H��D²b89s�`8�Mk��T��>ɋc�P�n�?��~���;�v�ߊX���c$�xR�Q�!��Vb��9�=��Y,r8�$�x��	��Rn�6o�z̯W��F�	$Z>C�o�G�BzX���0��fBI0��R���6{s����6��b��Y���9�Ӝ�ͣ�q��a#��1%Y\ռ��kN�&�N�>��J��g$/4���������J�����[A�2�QF!4mE8��T�|·����.>V����g꒡M&$0b���9����7H�Ipi���y����OTJb�ki8����ݬ9uK5�&�\¸xhB�A{T��1� ���3f�DIi��,�$�����ڤ��,�� ���)ʜ��IY�K^,�5�ߍ��+�%���H�*�����L�i:��ɋ��ɂ^[�:���#P�UL�JX���X�hiN��Pe;�p�N��wpPL,�8��~8�j�T�>c	,c(R=6�v��-�%��P���kݬ��}"�#K����J�3�!(�h|
	c'����W��x��t��(?� ���Ҙ�L� ~!j�B���H^�)t��R��%e�kD�,gV���(�Г�9�����l,��F;*6�e��ntU�(IG0	��P�$fN��i��|F����D���H�>�WG��ܝ�2�YN��گS�Y�S�h�� �!�9��/VOD�%�h$�RCӄ�˵I4�N2H^��t9��OE	�6%y1'd �m�9��W?��0H^�;!{��C-����G�	�� �w���I�Xb5FB��$���/��"�����1I?w\��f�h"� yqj�CJǃC*e��4=ux�ҚF�mie	0c�-̠���46sĒG�ςś7��˸�6���=�V���$��^���2���`�\:�(�~�G����]it�����w�B?H^G�D�R��I>P����a��#������Bi�]��G�{��.�9�e�wP'Qd��$L9l�!P%M�njz#{uD�E�G�� "B搧J���D�q4^���f�2[���1��$��8QŊF=Uj�tn�L�^3���{&���V��(=Aqc�R�'#~bmh0�x?���G����b�33�T�EƒCh�������b����bU E
�'\l�M��ra?�{[��le�r�b���aNR��c#^A���I����[���or��{��WA�ZVj��1���Mq�}%���A̸M�ⴹ�W�rsT�T8�j:H �	�,iN��(MI$/��7���4��ۢ|����&�q�dj9�0��!��u�6��Y�,^K@��qU�u�]]9�Zpm3K��H`Ć�' 3j#�TY�zF�=����6�m���	:��C���d#y1g�����l�9Ued�mF�-\��|EG�LoJ�9�f��{�c8��hhN��x��@�x1���W��u��t%�����ͬX�Ɩ����S� �shsj���gƒHS������oK��1RO1f�FE�7	(c2�o'�ɪ�S�OM����8�X	Dc@��Yfǹ�j;2K��H@K��ݮ펷L�bU�����L�(��@2&5jN���+��g	<c@��M]}-V�n=%�*Kj��@0��[bNM�P�j�8�ld�zy���*8:p#�Z���ř��<\�Y5ˤ%�f$Op �����ۮ0�_��𐅔ƶ�G
8��h'hN�Rz�pB�MGl"�7��X��7\���f�S��"��	N!��>���7�j(g�u�%Op&!���%<�E�U�wE�H��oi=�P�4������PF��NH`�u�c�FIa�����W~�_8��f;�����Klcp���gGͨ^��%��H�ɀ���Co�Nɫ�lEHK+ d��Y5��Q��<�y/�>��OK��鹣�0�m����i��? ��"LK��@1!���(�,�YF�DhL@2Z�Y�rI$,�2+�͔O�7t���0���<r]M�̒��
@f��O���ӯvМj�ﶜ6���
%%�zE.	&�Q����568�(� ͩ:\XjŒ'8�F��\�ѕj��rP���TNH(���<�ļ�J_�̛�����w&����o$�x�qP�op �'�c�ʧ�:���������������rw��!,���G����7���l�N� �|�62������j�ͣ�I4H<ad|H�_�Ԗ'�
J�i"E_�����OUDчM&$�x�D����D%ʒn$OpN1��a f��L]��0����	N(��:Q�뒉ĲQ4�'8��^���_,�)[�(�>*�,6�x��魋ج��4��0c��t����?��U�^� ;�Bi #K��� ��O7�ƀ�{*T��~F�-A�.~o�UE��m�N�����̢�0�,1�x�)�i��|���Q�DZ�F�-B��U�W_� �ß��a	6i�D�W�>=wC�r|�	�i806���cʒu��'L�5�D��٭룪G�%�H������䫶���G0��bˌ��Tc��g�s�	��	��tpf8d��w�'$O��g,Λ}��������X�T����&�Y����7�������YI�8ϋ���s��t���N�r���Tf²53�rq�]��� ��#g������sWc%���������&4�;~���s:��'�&$Op�3]3�,�Bsk����\�K� ���F,d�Z��OY���m���TD�e�a���LO[��l@� ��(���*�k�H��fX��,�G���t��:P*
-�I#%.>�n��O�4!��w%����m�$}zf�@�)K����:,r}R����š��=�����{���Q��q�`;�}�&m	� "c��M���lDe�3�{�
��D�wX�����Ӯ�o���]&��: *���	�#�~���)}�MK��g�i���j��ġ��)�=!�-�k��ݣ	ʶ���x�����Mḑ��0��P��	Π�K�|HV�'�н�]��^pt����sF#��Ʀ�u�����(M�����~��rM~bu�8��	N��ۅ7\������\�&T�Iji@R b+��sY�Ԅ��5=DO    �7��5ܷ��MQ`{P�H��4j�6�p�[�Ą�câ�XY,�� �9�M�i�@���z�3�[?��.�|q�x���Y7xlȆP�%�Sc�K�tk`Ƴ	*SK��H�����7N9�3�����v����	,���#��������$���fay��{~��+���N<�^l	���L��.�o��/���9s���+���b X�G9F)6�pp/?���0�7"T)��c$x���~O0_(r��(K�P>iٟAw��.����Z�����}�>R��M����#'���%�x8'�7�lME$�~9�f����'8��.x�9��\\�R�u���	Nd�{0��ݲ��Ò�e%7X�����8�����,Tf9Kf ^�`Ŀ�.�n�#��*���Bc	86	��ߎZY[n�chʶu0hl`�ifs���||��F2�'8�����®��͘����OgH����Xmtu�F���3�kW3E`�4P<�1�QK�݅}@��0F�g0��3`W�'�-8E�e�3�'8u�2(�!������2��ḝ58<o1�*��	�.�z%��X�'�Q��3�6+�yS�ܵO+�<7�u#�SV%?�fu��h��P>MJ�!�����ў���������/}�'8c�ru���U]ݙ��~�9ʗ�}�}�<��Z����Sm8nE{��ٷ��=���Jh�i��^��`�3{���&���`�����ͧ��%�h$Or���\i��zL�-[��zfbdy��H��-:��z��׳�3�&�+��XZ]�`���3�'9a��t.��)���j�>(}��%=|�����@Ǻm�Q,y�3�(G��F�}��V��� 4BZ���8�bi3�,y�s�D)|m��C��c�O�X��q���$+���-J�1��(�G6x�f�1�)�U`s,ɓ��%�[�������q��}�ؔ$Orʖ�8�t�D�����oo.�'O�T�c���I��"c|K�p���з����o)^{�/ﰣ�ޕ��0}�W<��[����Ն��G��߯�'ߨ�Be6�F� y�Ӹ(�Ǽ�ob�� ���%\��R��MP$OrJ��'��%y�s��9L"�\�$Orf0�w�˒>�k1$�>}�=�Z&��T�:̓�IN������l�*�c�o�}NϽ9@q0��G�x��(��͞�C��9���~t��BA�'9�R
�KA����D=��2�C;���'�Q{�+���+�)�	�	B�k�Q�^�$_��f��{6�����[�� ��{ �3=�$Or4��L����?���֌�kr�����+��21dc�պ�T�UE���1�٭)�`4d�<�`vWuE��;�m������]�J�y���OI@Ō
��W�~���m���`R�8���_Z��⋇/���j��3��b`iE� ��C��vhL�n��HƿO2H(>����=/�<8^<6��ӗ���m�X�x8{��82/yf#��w�_���ދT�-A� �/��\��a.T���cH�5<JM�v�0_#���#���P�/^b�NgZ�gǈ�1�K�??s���ocM$^�*	�8�d��/�����#�3'�_k5�(P|�����j�7�!�0���!j�CRE�����L������Ø��1���7G11��H������$G`��s�b$��Of�H��"O�K(��b�����mNK)�F�>�t����4�oc���d����e�;�B�'�;Gf}�D�+)�L�8�:x���k�(9�3CL<o���W���v��i     