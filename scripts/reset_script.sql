SELECT SETVAL('public.composers_id_seq', MAX(id) ) FROM public.composers;
SELECT SETVAL('public.evensongs_id_seq', MAX(id) ) FROM public.evensongs;
SELECT SETVAL('public.genres_id_seq', MAX(id) ) FROM public.genres;
SELECT SETVAL('public.languages_id_seq', MAX(id) ) FROM public.languages;
SELECT SETVAL('public.links_id_seq', MAX(id) ) FROM public.links;
SELECT SETVAL('public.messages_id_seq', MAX(id) ) FROM public.messages;
SELECT SETVAL('public.notes_id_seq', MAX(id) ) FROM public.notes;
SELECT SETVAL('public.periods_id_seq', MAX(id) ) FROM public.periods;
SELECT SETVAL('public.roles_id_seq', MAX(id) ) FROM public.roles;
SELECT SETVAL('public.uploads_id_seq', MAX(id) ) FROM public.uploads;
SELECT SETVAL('public.user_role_relations_id_seq', MAX(id) ) FROM public.user_role_relations;
SELECT SETVAL('public.users_id_seq', MAX(id) ) FROM public.users;
