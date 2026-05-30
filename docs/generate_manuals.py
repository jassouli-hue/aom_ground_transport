"""
AOM Logistics Ground Transport — Génération des deux manuels PDF
Manuel Utilisateur + Documentation DGAC
"""

from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm, mm
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, HRFlowable, KeepTogether
)
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_JUSTIFY, TA_RIGHT
from reportlab.platypus import BaseDocTemplate, Frame, PageTemplate
from reportlab.pdfgen import canvas as pdfcanvas
from datetime import datetime
import os

# ─── Couleurs AOM ─────────────────────────────────────────────────────────────
AOM_DARK_BLUE  = colors.HexColor('#003366')
AOM_RED        = colors.HexColor('#C62828')
AOM_GREEN      = colors.HexColor('#2E7D32')
AOM_GOLD       = colors.HexColor('#E8A020')
AOM_LIGHT_GREY = colors.HexColor('#F5F7FA')
AOM_MID_GREY   = colors.HexColor('#E0E4ED')
WHITE          = colors.white
BLACK          = colors.black

DATE_STR  = datetime.now().strftime('%d/%m/%Y')
YEAR      = datetime.now().year

OUTPUT_DIR = os.path.dirname(os.path.abspath(__file__))

# ─── Styles communs ───────────────────────────────────────────────────────────
def build_styles():
    styles = getSampleStyleSheet()
    custom = {}

    custom['cover_title'] = ParagraphStyle('cover_title',
        fontName='Helvetica-Bold', fontSize=26, textColor=WHITE,
        alignment=TA_CENTER, leading=32)

    custom['cover_sub'] = ParagraphStyle('cover_sub',
        fontName='Helvetica', fontSize=14, textColor=colors.HexColor('#BDD7EE'),
        alignment=TA_CENTER, leading=20)

    custom['cover_meta'] = ParagraphStyle('cover_meta',
        fontName='Helvetica', fontSize=10, textColor=colors.HexColor('#90A4AE'),
        alignment=TA_CENTER, leading=14)

    custom['h1'] = ParagraphStyle('h1',
        fontName='Helvetica-Bold', fontSize=16, textColor=AOM_DARK_BLUE,
        spaceBefore=20, spaceAfter=8, leading=20)

    custom['h2'] = ParagraphStyle('h2',
        fontName='Helvetica-Bold', fontSize=13, textColor=AOM_DARK_BLUE,
        spaceBefore=14, spaceAfter=6, leading=16)

    custom['h3'] = ParagraphStyle('h3',
        fontName='Helvetica-BoldOblique', fontSize=11, textColor=AOM_RED,
        spaceBefore=10, spaceAfter=4, leading=14)

    custom['body'] = ParagraphStyle('body',
        fontName='Helvetica', fontSize=10, textColor=colors.HexColor('#1A1A2E'),
        spaceBefore=4, spaceAfter=4, leading=14, alignment=TA_JUSTIFY)

    custom['bullet'] = ParagraphStyle('bullet',
        fontName='Helvetica', fontSize=10, textColor=colors.HexColor('#1A1A2E'),
        spaceBefore=2, spaceAfter=2, leading=13, leftIndent=16,
        bulletIndent=6)

    custom['note'] = ParagraphStyle('note',
        fontName='Helvetica-Oblique', fontSize=9, textColor=colors.HexColor('#555555'),
        spaceBefore=4, spaceAfter=4, leading=12, leftIndent=12,
        borderPad=4)

    custom['code'] = ParagraphStyle('code',
        fontName='Courier', fontSize=9, textColor=AOM_DARK_BLUE,
        spaceBefore=4, spaceAfter=4, leading=12, leftIndent=12,
        backColor=colors.HexColor('#EEF2F7'), borderPad=6)

    custom['table_header'] = ParagraphStyle('table_header',
        fontName='Helvetica-Bold', fontSize=9, textColor=WHITE,
        alignment=TA_CENTER, leading=12)

    custom['table_cell'] = ParagraphStyle('table_cell',
        fontName='Helvetica', fontSize=9, textColor=BLACK,
        alignment=TA_LEFT, leading=12)

    custom['footer'] = ParagraphStyle('footer',
        fontName='Helvetica', fontSize=8, textColor=colors.HexColor('#888888'),
        alignment=TA_CENTER)

    return custom


def info_box(text, styles, color=AOM_LIGHT_GREY, border=AOM_MID_GREY):
    data = [[Paragraph(text, styles['note'])]]
    t = Table(data, colWidths=[16*cm])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), color),
        ('BOX', (0,0), (-1,-1), 0.5, border),
        ('TOPPADDING', (0,0), (-1,-1), 6),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('LEFTPADDING', (0,0), (-1,-1), 10),
    ]))
    return t


def section_table(rows, col_widths, styles, header=True):
    tdata = []
    for i, row in enumerate(rows):
        tdata.append([Paragraph(str(c), styles['table_header'] if (header and i==0) else styles['table_cell'])
                      for c in row])
    t = Table(tdata, colWidths=col_widths)
    ts = [
        ('GRID', (0,0), (-1,-1), 0.4, AOM_MID_GREY),
        ('ROWBACKGROUNDS', (0,0), (-1,-1), [WHITE, colors.HexColor('#F8FAFC')]),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 7),
    ]
    if header:
        ts += [
            ('BACKGROUND', (0,0), (-1,0), AOM_DARK_BLUE),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [WHITE, colors.HexColor('#F0F4F8')]),
        ]
    t.setStyle(TableStyle(ts))
    return t

# ══════════════════════════════════════════════════════════════════════════════
#  MANUEL UTILISATEUR
# ══════════════════════════════════════════════════════════════════════════════

def build_user_manual():
    styles = build_styles()
    path = os.path.join(OUTPUT_DIR, 'AOM_GT_Manuel_Utilisateur.pdf')

    # Page numéros + en-tête/pied
    page_count = [0]

    def on_page(c, doc):
        page_count[0] += 1
        w, h = A4
        # Bandeau haut
        c.setFillColor(AOM_DARK_BLUE)
        c.rect(0, h - 20*mm, w, 20*mm, fill=1, stroke=0)
        c.setFillColor(WHITE)
        c.setFont('Helvetica-Bold', 9)
        c.drawString(18*mm, h - 13*mm, 'AOM LOGISTICS — Ground Transport Mobile')
        c.setFont('Helvetica', 8)
        c.drawRightString(w - 18*mm, h - 13*mm, 'Manuel Utilisateur  v1.0')
        # Pied de page
        c.setFillColor(AOM_DARK_BLUE)
        c.rect(0, 0, w, 12*mm, fill=1, stroke=0)
        c.setFillColor(WHITE)
        c.setFont('Helvetica', 8)
        c.drawString(18*mm, 4*mm, f'Issue 1 Rev 0 — {DATE_STR} — CONFIDENTIEL AOM')
        c.drawRightString(w - 18*mm, 4*mm, f'Page {doc.page}')

    doc = SimpleDocTemplate(
        path, pagesize=A4,
        topMargin=2.5*cm, bottomMargin=2.2*cm,
        leftMargin=2*cm, rightMargin=2*cm,
        title='AOM GT Manuel Utilisateur',
        author='AIR OCEAN MAROC',
    )

    story = []
    S = styles

    # ── PAGE DE COUVERTURE ──────────────────────────────────────────────────
    story.append(Spacer(1, 3*cm))

    cover_data = [[Paragraph('AOM LOGISTICS', S['cover_title'])],
                  [Paragraph('GROUND TRANSPORT MOBILE', S['cover_title'])],
                  [Spacer(1, 8*mm)],
                  [Paragraph('Manuel Utilisateur', S['cover_sub'])],
                  [Paragraph('Guide d\'utilisation de l\'application mobile\nde gestion des missions de transport terrestre', S['cover_sub'])],
                  [Spacer(1, 12*mm)],
                  [Paragraph(f'Issue 1 &nbsp;·&nbsp; Rev 0 &nbsp;·&nbsp; {DATE_STR}', S['cover_meta'])],
                  [Paragraph('Réservé aux agents autorisés AIR OCEAN MAROC', S['cover_meta'])],
                  ]
    cover = Table(cover_data, colWidths=[17*cm])
    cover.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), AOM_DARK_BLUE),
        ('TOPPADDING', (0,0), (-1,-1), 6),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('LEFTPADDING', (0,0), (-1,-1), 20),
        ('RIGHTPADDING', (0,0), (-1,-1), 20),
    ]))
    story.append(cover)
    story.append(Spacer(1, 1*cm))

    # Info doc
    meta = [
        ['Document', 'AOM-GT-MU-001'],
        ['Titre', 'Manuel Utilisateur — Ground Transport Mobile'],
        ['Version', 'Issue 1, Révision 0'],
        ['Date', DATE_STR],
        ['Préparé par', 'Direction des Systèmes d\'Information — AOM'],
        ['Approuvé par', 'Directeur des Opérations'],
        ['Classification', 'Usage Interne — Confidentiel'],
    ]
    t = Table([[Paragraph(r[0], S['table_header']), Paragraph(r[1], S['table_cell'])]
               for r in meta], colWidths=[5*cm, 12*cm])
    t.setStyle(TableStyle([
        ('GRID', (0,0), (-1,-1), 0.5, AOM_MID_GREY),
        ('BACKGROUND', (0,0), (0,-1), AOM_DARK_BLUE),
        ('FONTNAME', (0,0), (0,-1), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,-1), 9),
        ('TEXTCOLOR', (0,0), (0,-1), WHITE),
        ('ROWBACKGROUNDS', (1,0), (1,-1), [WHITE, AOM_LIGHT_GREY]),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(t)
    story.append(PageBreak())

    # ── SOMMAIRE ───────────────────────────────────────────────────────────
    story.append(Paragraph('TABLE DES MATIÈRES', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1.5, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 4*mm))

    toc = [
        ('1.', 'Introduction et présentation de l\'application', '3'),
        ('2.', 'Installation et premier démarrage', '3'),
        ('3.', 'Paramétrage initial', '4'),
        ('4.', 'Gestion des chauffeurs', '5'),
        ('5.', 'Gestion des véhicules', '5'),
        ('6.', 'Gestion des passagers (membres d\'équipage)', '6'),
        ('7.', 'Gestion des destinations', '7'),
        ('8.', 'Création d\'une mission', '7'),
        ('9.', 'Suivi et modification d\'une mission', '9'),
        ('10.', 'Ajout et réorganisation des étapes', '10'),
        ('11.', 'Notifications WhatsApp', '11'),
        ('12.', 'Export rapport PDF', '12'),
        ('13.', 'Notifications push automatiques', '13'),
        ('14.', 'Sauvegarde des données', '13'),
        ('Annexe A', 'Glossaire', '14'),
    ]
    for num, title, page in toc:
        row = Table([[
            Paragraph(f'<b>{num}</b>', S['body']),
            Paragraph(title, S['body']),
            Paragraph(page, S['body']),
        ]], colWidths=[1.5*cm, 13.5*cm, 2*cm])
        row.setStyle(TableStyle([
            ('ALIGN', (2,0), (2,0), 'RIGHT'),
            ('TOPPADDING', (0,0), (-1,-1), 2),
            ('BOTTOMPADDING', (0,0), (-1,-1), 2),
            ('LINEBELOW', (0,0), (-1,-1), 0.3, AOM_MID_GREY),
        ]))
        story.append(row)

    story.append(PageBreak())

    # ── 1. INTRODUCTION ────────────────────────────────────────────────────
    story.append(Paragraph('1. Introduction et présentation de l\'application', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph(
        'L\'application <b>AOM Logistics Ground Transport Mobile</b> est l\'outil numérique officiel '
        'd\'AIR OCEAN MAROC pour la gestion des missions de transport terrestre des membres d\'équipage. '
        'Elle permet de planifier, suivre et documenter l\'ensemble des transferts entre la base AOM, '
        'les domiciles des équipages et les aéroports de départ ou d\'arrivée.',
        S['body']))
    story.append(Spacer(1, 3*mm))

    features = [
        ['Fonctionnalité', 'Description'],
        ['Gestion des missions', 'Création, modification, suivi en temps réel du statut'],
        ['Calcul des distances', 'Distances routières réelles via API OSRM (OpenStreetMap)'],
        ['Notifications WhatsApp', 'Envoi personnalisé aux chauffeurs et passagers'],
        ['Notifications push', 'Rappel automatique 15 min avant chaque mission'],
        ['Export PDF', 'Rapport des missions avec filtres période / chauffeur / véhicule'],
        ['Itinéraire Maps', 'Lien Google Maps avec tous les points de passage'],
        ['Gestion d\'équipage', 'Fiches chauffeurs, passagers, véhicules, destinations'],
    ]
    story.append(section_table(features, [5*cm, 12*cm], S))
    story.append(Spacer(1, 4*mm))
    story.append(info_box(
        '<b>Compatibilité :</b> Android 8.0 (API 26) et supérieur. '
        'Testé sur Samsung Galaxy S22 (Android 16). '
        'Connexion internet requise pour le calcul des distances et l\'envoi WhatsApp.',
        S))

    # ── 2. INSTALLATION ────────────────────────────────────────────────────
    story.append(Paragraph('2. Installation et premier démarrage', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('2.1 Installation depuis le fichier APK', S['h2']))
    steps_install = [
        '1. Recevoir le fichier <b>AOM_GT_release.apk</b> (par email ou partage interne AOM).',
        '2. Sur l\'appareil Android, aller dans <b>Paramètres → Applications → Sources inconnues</b> → Activer.',
        '3. Ouvrir le fichier APK depuis le gestionnaire de fichiers.',
        '4. Appuyer sur <b>Installer</b> et attendre la fin de l\'installation.',
        '5. L\'icône <b>Logistics AOM</b> apparaît sur l\'écran d\'accueil.',
    ]
    for s in steps_install:
        story.append(Paragraph(s, S['bullet']))
    story.append(Spacer(1, 3*mm))
    story.append(info_box(
        '<b>Note :</b> Au premier lancement, l\'application demande l\'autorisation d\'envoyer des '
        'notifications. Appuyer sur <b>Autoriser</b> pour activer les rappels automatiques avant mission.',
        S, color=colors.HexColor('#E8F5E9'), border=AOM_GREEN))

    story.append(Paragraph('2.2 Données de démonstration', S['h2']))
    story.append(Paragraph(
        'Au premier lancement, l\'application charge automatiquement des données initiales : '
        'chauffeurs, véhicules, passagers (équipage AOM), destinations (aéroports Maroc) et '
        'paramètres par défaut (base AOM Casablanca, vitesse 80 km/h).',
        S['body']))

    # ── 3. PARAMÉTRAGE ─────────────────────────────────────────────────────
    story.append(Paragraph('3. Paramétrage initial', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph(
        'Accès : <b>Tableau de bord → ⚙ Paramètres</b> (icône engrenage en haut à droite).',
        S['body']))
    story.append(Spacer(1, 2*mm))

    params = [
        ['Paramètre', 'Description', 'Valeur par défaut'],
        ['Base de départ', 'Localisation de départ de tous les véhicules AOM', 'Base AOM Casablanca'],
        ['Vitesse moyenne', 'Vitesse utilisée pour estimer les durées de trajet', '80 km/h'],
        ['PIN de verrouillage', 'Code PIN 4-6 chiffres pour sécuriser l\'accès', 'Désactivé'],
    ]
    story.append(section_table(params, [4*cm, 9*cm, 4*cm], S))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('Modifier la base de départ :', S['h3']))
    steps_base = [
        '1. Taper sur la ligne <b>Base de départ</b>.',
        '2. Un panneau s\'ouvre depuis le bas avec la liste des destinations enregistrées.',
        '3. Sélectionner la nouvelle base → Un message de confirmation vert s\'affiche.',
    ]
    for s in steps_base:
        story.append(Paragraph(s, S['bullet']))

    # ── 4. CHAUFFEURS ──────────────────────────────────────────────────────
    story.append(Paragraph('4. Gestion des chauffeurs', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Accès : <b>Tableau de bord → Chauffeurs</b>. La liste affiche tous les chauffeurs actifs '
        'avec leur nom et numéro de téléphone.',
        S['body']))

    ops_chauf = [
        ['Action', 'Comment faire'],
        ['Ajouter un chauffeur', 'Bouton + (flottant) → Remplir Nom + Téléphone → Créer'],
        ['Modifier', 'Taper sur le chauffeur → Icône crayon → Modifier → Enregistrer'],
        ['Désactiver', 'Taper sur le chauffeur → Menu ⋮ → Désactiver'],
        ['Format téléphone', '+212XXXXXXXXX (avec indicatif pays)'],
    ]
    story.append(section_table(ops_chauf, [5*cm, 12*cm], S))

    # ── 5. VÉHICULES ───────────────────────────────────────────────────────
    story.append(Paragraph('5. Gestion des véhicules', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Accès : <b>Tableau de bord → Véhicules</b>. Chaque fiche véhicule contient la marque, '
        'l\'immatriculation et la capacité de transport.',
        S['body']))

    ops_veh = [
        ['Champ', 'Exemple', 'Obligatoire'],
        ['Marque / Modèle', 'Ford Transit, Mercedes Vito', 'Oui'],
        ['Immatriculation', 'AOM-001', 'Oui'],
        ['Capacité', '4 à 9 passagers', 'Oui'],
    ]
    story.append(section_table(ops_veh, [4*cm, 8*cm, 5*cm], S))

    # ── 6. PASSAGERS ───────────────────────────────────────────────────────
    story.append(Paragraph('6. Gestion des passagers (membres d\'équipage)', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Les passagers correspondent aux membres de l\'équipage AOM (Commandants de bord, Copilotes, '
        'Hôtesses, Docteurs, Infirmiers). Chaque fiche peut inclure une position GPS de domicile '
        'pour optimiser les itinéraires de ramassage.',
        S['body']))

    ops_pax = [
        ['Champ', 'Description', 'Obligatoire'],
        ['Nom', 'Nom complet du membre d\'équipage', 'Oui'],
        ['Rôle / Fonction', 'CDB, Copilote, Hôtesse, Docteur, Infirmier…', 'Oui'],
        ['Téléphone', 'Numéro WhatsApp (+212…)', 'Oui'],
        ['Ville de résidence', 'Casablanca, Rabat, Mohammedia…', 'Oui'],
        ['Position GPS', 'Coordonnées domicile (optionnel, via carte)', 'Non'],
    ]
    story.append(section_table(ops_pax, [4*cm, 9*cm, 4*cm], S))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph('Définir la position GPS :', S['h3']))
    story.append(Paragraph(
        'Dans la fiche passager, appuyer sur <b>"Définir position sur la carte"</b>. '
        'Une carte OpenStreetMap s\'ouvre. Appuyer longuement sur la carte pour placer le marqueur '
        'à la position exacte du domicile, puis valider. Les coordonnées WGS84 s\'affichent dans la fiche.',
        S['body']))

    story.append(PageBreak())

    # ── 7. DESTINATIONS ────────────────────────────────────────────────────
    story.append(Paragraph('7. Gestion des destinations', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Les destinations sont les lieux nommés utilisables dans les missions : aéroports, '
        'bases, centres-villes. Accès : <b>Tableau de bord → Destinations</b>.',
        S['body']))

    dest_pre = [
        ['Destination', 'Code OACI', 'Ville'],
        ['Aéroport Mohammed V Casablanca', 'GMMN', 'Casablanca'],
        ['Aéroport Rabat-Salé', 'GMME', 'Rabat-Salé'],
        ['Aéroport Benslimane', 'GMMB', 'Benslimane'],
        ['Aéroport Marrakech Menara', 'GMMX', 'Marrakech'],
        ['Aéroport Fès-Saïss', 'GMFF', 'Fès'],
        ['Aéroport Tanger Ibn Battouta', 'GMTT', 'Tanger'],
        ['Base AOM Casablanca', 'BASE', 'Casablanca'],
        ['Casablanca Centre', 'CASA', 'Casablanca'],
    ]
    story.append(section_table(dest_pre, [7*cm, 3*cm, 7*cm], S))

    # ── 8. CRÉATION MISSION ────────────────────────────────────────────────
    story.append(Paragraph('8. Création d\'une mission', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Accès : <b>Bouton "Nouvelle mission"</b> (bas de l\'écran d\'accueil, icône +).',
        S['body']))
    story.append(Spacer(1, 2*mm))

    story.append(Paragraph('Champs à remplir :', S['h2']))
    champs = [
        ['Champ', 'Description', 'Obligatoire'],
        ['Référence', 'Ex. : AOM-2026-352 (pré-rempli, modifiable)', 'Oui'],
        ['Type', 'DÉPART (vers aéroport) ou ARRIVÉE (depuis aéroport)', 'Oui'],
        ['Date et heure', 'Date/heure prévue de la mission', 'Oui'],
        ['Chauffeur', 'Sélection depuis la liste des chauffeurs actifs', 'Oui'],
        ['Véhicule', 'Sélection depuis la liste des véhicules actifs', 'Oui'],
        ['Destination', 'Aéroport ou lieu de destination', 'Oui'],
        ['Retour à la base', 'Inclure le retour base dans l\'itinéraire', 'Non'],
        ['Passagers', 'Sélection + lieu de prise en charge + GPS optionnel', 'Non'],
        ['Notes', 'Informations complémentaires libres', 'Non'],
    ]
    story.append(section_table(champs, [4*cm, 9.5*cm, 3.5*cm], S))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('Ajouter des passagers :', S['h3']))
    steps_pax = [
        '1. Dans la section Passagers, appuyer sur <b>Ajouter</b>.',
        '2. Sélectionner le membre de l\'équipage dans la liste.',
        '3. Saisir ou modifier le lieu de prise en charge (pré-rempli avec la ville de résidence).',
        '4. Optionnel : appuyer sur <b>"Choisir sur la carte"</b> pour positionner le pickup précisément.',
        '5. Répéter pour chaque passager.',
    ]
    for s in steps_pax:
        story.append(Paragraph(s, S['bullet']))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('Calcul automatique :', S['h3']))
    story.append(Paragraph(
        'À la validation, l\'application calcule automatiquement via l\'API <b>OSRM (OpenStreetMap)</b> :'
        ' les distances routières réelles entre chaque étape, la durée estimée de chaque tronçon, '
        'la distance totale, et génère un lien <b>Google Maps</b> avec tous les arrêts visibles.',
        S['body']))
    story.append(Spacer(1, 3*mm))
    story.append(info_box(
        '<b>Fallback réseau :</b> Si l\'appareil n\'a pas accès à internet lors de la création, '
        'les distances sont calculées par la formule Haversine (vol d\'oiseau × 1.25). '
        'Le recalcul OSRM se fera automatiquement lors de la prochaine modification.',
        S))

    # ── 9. SUIVI ET MODIFICATION ───────────────────────────────────────────
    story.append(Paragraph('9. Suivi et modification d\'une mission', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('9.1 Statuts de mission', S['h2']))
    statuts = [
        ['Statut', 'Signification', 'Actions disponibles'],
        ['🔵 PLANIFIÉE', 'Mission créée, en attente de départ', 'Modifier, Démarrer, Annuler'],
        ['🟡 EN COURS', 'Mission en cours d\'exécution', 'Modifier étapes, Terminer, Annuler'],
        ['🟢 TERMINÉE', 'Mission accomplie', 'Consultation uniquement'],
        ['⚫ ANNULÉE', 'Mission annulée', 'Consultation uniquement'],
    ]
    story.append(section_table(statuts, [3.5*cm, 6*cm, 7.5*cm], S))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('9.2 Modifier une mission', S['h2']))
    story.append(Paragraph(
        'Une mission PLANIFIÉE ou EN COURS peut être modifiée intégralement : '
        'appuyer sur le menu <b>⋮ → Modifier la mission</b>. '
        'Tous les champs sont modifiables (chauffeur, véhicule, date, passagers, destination). '
        'Les distances et le lien Maps sont recalculés automatiquement.',
        S['body']))
    story.append(Spacer(1, 2*mm))
    story.append(info_box(
        '<b>Attention :</b> Marquer une mission comme "Terminée" pour une mission dont la date est '
        'dans le futur nécessite une confirmation explicite.',
        S, color=colors.HexColor('#FFF3E0'), border=AOM_GOLD))

    # ── 10. ÉTAPES ─────────────────────────────────────────────────────────
    story.append(Paragraph('10. Ajout et réorganisation des étapes', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Sur une mission PLANIFIÉE ou EN COURS, la section <b>Itinéraire</b> dispose d\'un bouton '
        '"+ Ajouter étape". Cette fonctionnalité permet d\'insérer un point de passage supplémentaire '
        'sans recréer toute la mission.',
        S['body']))

    story.append(Paragraph('10.1 Ajouter une étape', S['h2']))
    steps_etape = [
        '1. Ouvrir la mission → Section <b>Itinéraire → "+ Ajouter étape"</b>.',
        '2. Choisir le mode :\n   • <b>Lieu enregistré</b> : rechercher parmi les destinations AOM\n   • <b>Nouveau lieu</b> : saisir nom + ville + GPS optionnel',
        '3. Sélectionner la <b>position dans l\'itinéraire</b> (avant ou après chaque étape existante).',
        '4. Appuyer sur <b>"Ajouter cette étape"</b>.',
        '5. Les distances sont recalculées automatiquement via OSRM.',
    ]
    for s in steps_etape:
        story.append(Paragraph(s, S['bullet']))

    story.append(Paragraph('10.2 Réorganiser les étapes', S['h2']))
    story.append(Paragraph(
        'Chaque étape PICKUP affiche deux boutons ▲ et ▼ pour la monter ou la descendre dans '
        'l\'ordre de l\'itinéraire. La destination et le retour base restent fixes en fin d\'itinéraire. '
        'Après chaque déplacement, les distances sont recalculées.',
        S['body']))

    story.append(Paragraph('10.3 Supprimer une étape', S['h2']))
    story.append(Paragraph(
        'Appuyer sur l\'icône × rouge sur l\'étape à supprimer → confirmer → '
        'les distances du tronçon adjacent sont recalculées.',
        S['body']))

    # ── 11. WHATSAPP ───────────────────────────────────────────────────────
    story.append(PageBreak())
    story.append(Paragraph('11. Notifications WhatsApp', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph(
        'L\'application génère des messages WhatsApp personnalisés pour le chauffeur et chaque passager. '
        'Les messages incluent les détails de la mission, l\'itinéraire et le lien Google Maps.',
        S['body']))

    story.append(Paragraph('11.1 Envoyer à Tous', S['h2']))
    story.append(Paragraph(
        'Le bouton <b>"Envoyer à Tous"</b> (vert, à côté de Google Maps) ouvre un panneau '
        'listant tous les destinataires avec un bouton Envoyer individuel pour chacun. '
        'Appuyer sur chaque bouton ouvre directement la conversation WhatsApp correspondante '
        'avec le message pré-rempli.',
        S['body']))

    story.append(Paragraph('11.2 Envoi individuel', S['h2']))
    story.append(Paragraph(
        'Dans la section <b>"Notifications WhatsApp"</b>, chaque destinataire dispose :\n'
        '• Bouton <b>WhatsApp</b> (vert) → ouvre directement la conversation\n'
        '• Bouton <b>Copier</b> → copie le message dans le presse-papiers',
        S['body']))

    msgs = [
        ['Destinataire', 'Contenu du message'],
        ['Chauffeur', 'Référence mission, date, véhicule, liste des passagers avec points de pickup, itinéraire complet, lien Maps'],
        ['Passager', 'Référence, date, destination, lieu de prise en charge, nom du chauffeur, téléphone chauffeur, immatriculation véhicule'],
    ]
    story.append(section_table(msgs, [4*cm, 13*cm], S))

    # ── 12. RAPPORT PDF ────────────────────────────────────────────────────
    story.append(Paragraph('12. Export rapport PDF', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Accès : <b>Tableau de bord → Icône PDF</b> (en haut à droite) ou depuis la barre de navigation.',
        S['body']))

    rapport_steps = [
        '1. Définir la <b>période</b> : date de début et/ou date de fin.',
        '2. Filtrer par <b>Chauffeur</b> (optionnel).',
        '3. Filtrer par <b>Véhicule</b> (optionnel).',
        '4. L\'aperçu affiche en temps réel le nombre de missions et le total km.',
        '5. Appuyer sur <b>"Générer PDF"</b> → le rapport s\'ouvre dans le visualiseur natif Android.',
        '6. Partager via WhatsApp, email, Google Drive, imprimer, etc.',
    ]
    for s in rapport_steps:
        story.append(Paragraph(s, S['bullet']))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph('Le rapport PDF contient :', S['h3']))
    rapport_content = [
        '• En-tête : logo AOM Logistics + date de génération + filtres appliqués',
        '• Résumé statistique : total missions, planifiées, en cours, terminées, annulées, distance totale',
        '• Tableau détaillé : référence, date, type, chauffeur, véhicule, destination, distance, statut',
        '• Pied de page : numérotation des pages + mention confidentielle',
    ]
    for s in rapport_content:
        story.append(Paragraph(s, S['bullet']))

    # ── 13. NOTIFICATIONS PUSH ─────────────────────────────────────────────
    story.append(Paragraph('13. Notifications push automatiques', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'L\'application planifie automatiquement une notification push sur l\'appareil '
        '<b>15 minutes avant l\'heure prévue</b> de chaque mission.',
        S['body']))

    notif_rows = [
        ['Événement', 'Comportement notification'],
        ['Création mission', 'Rappel planifié à H-15 min'],
        ['Modification mission', 'Rappel replanifié à la nouvelle heure H-15 min'],
        ['Mission annulée', 'Rappel annulé automatiquement'],
        ['Mission terminée', 'Rappel annulé automatiquement'],
        ['Mission passée (H-15 déjà passé)', 'Pas de notification'],
    ]
    story.append(section_table(notif_rows, [6*cm, 11*cm], S))
    story.append(Spacer(1, 3*mm))
    story.append(info_box(
        '<b>Fuseau horaire :</b> Africa/Casablanca (UTC+1). '
        'La permission "Envoyer des notifications" doit être accordée au premier lancement.',
        S))

    # ── 14. SAUVEGARDE ─────────────────────────────────────────────────────
    story.append(Paragraph('14. Sauvegarde des données', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Accès : <b>Paramètres → Sauvegarde → Exporter les données</b>. '
        'Un fichier JSON est généré avec l\'ensemble des données (missions, chauffeurs, '
        'véhicules, passagers, paramètres). Ce fichier peut être sauvegardé sur Google Drive '
        'ou envoyé par email.',
        S['body']))

    story.append(info_box(
        '<b>Données locales :</b> Toutes les données sont stockées localement sur l\'appareil '
        'dans une base SQLite sécurisée. Aucune donnée n\'est transmise à des serveurs externes, '
        'à l\'exception des requêtes OSRM pour le calcul des distances (coordonnées GPS uniquement, '
        'anonymisées) et des liens WhatsApp (traitement côté WhatsApp).',
        S, color=colors.HexColor('#E3F2FD'), border=AOM_DARK_BLUE))

    # ── ANNEXE A ───────────────────────────────────────────────────────────
    story.append(PageBreak())
    story.append(Paragraph('Annexe A — Glossaire', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_DARK_BLUE))
    story.append(Spacer(1, 3*mm))

    glossaire = [
        ['Terme', 'Définition'],
        ['AOM', 'AIR OCEAN MAROC — Opérateur aérien basé à Casablanca'],
        ['Mission', 'Trajet organisé pour le transport d\'équipages entre la base et les aéroports'],
        ['PICKUP', 'Point de prise en charge d\'un passager lors d\'une mission'],
        ['OSRM', 'Open Source Routing Machine — moteur de calcul d\'itinéraires OpenStreetMap'],
        ['WGS84', 'World Geodetic System 1984 — système de coordonnées GPS utilisé mondialement'],
        ['APK', 'Android Package — format de fichier d\'installation application Android'],
        ['DGAC', 'Direction Générale de l\'Aviation Civile — autorité de tutelle au Maroc'],
        ['WhatsApp', 'Application de messagerie utilisée pour les notifications d\'équipage'],
    ]
    story.append(section_table(glossaire, [3.5*cm, 13.5*cm], S))

    story.append(Spacer(1, 1*cm))
    story.append(HRFlowable(width='100%', thickness=0.5, color=AOM_MID_GREY))
    story.append(Spacer(1, 4*mm))
    story.append(Paragraph(
        '<i>Document propriété exclusive d\'AIR OCEAN MAROC. '
        'Reproduction et diffusion interdites sans autorisation écrite de la Direction.</i>',
        S['note']))

    doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
    print(f'[OK] Manuel Utilisateur : {path}')
    return path

# ══════════════════════════════════════════════════════════════════════════════
#  DOCUMENTATION DGAC
# ══════════════════════════════════════════════════════════════════════════════

def build_dgac_manual():
    styles = build_styles()
    path = os.path.join(OUTPUT_DIR, 'AOM_GT_Documentation_DGAC.pdf')
    S = styles

    def on_page(c, doc):
        w, h = A4
        c.setFillColor(AOM_DARK_BLUE)
        c.rect(0, h - 20*mm, w, 20*mm, fill=1, stroke=0)
        c.setFillColor(WHITE)
        c.setFont('Helvetica-Bold', 9)
        c.drawString(18*mm, h - 13*mm, 'AIR OCEAN MAROC — DGAC DOCUMENTATION')
        c.setFont('Helvetica', 8)
        c.drawRightString(w - 18*mm, h - 13*mm, 'AOM-GT-DOC-DGAC-001 | Issue 1 Rev 0')
        c.setFillColor(AOM_RED)
        c.rect(0, 0, w, 12*mm, fill=1, stroke=0)
        c.setFillColor(WHITE)
        c.setFont('Helvetica-Bold', 8)
        c.drawString(18*mm, 4*mm, 'CONFIDENTIEL — USAGE RÉGLEMENTAIRE DGAC MAROC')
        c.drawRightString(w - 18*mm, 4*mm, f'Page {doc.page} | {DATE_STR}')

    doc = SimpleDocTemplate(
        path, pagesize=A4,
        topMargin=2.5*cm, bottomMargin=2.2*cm,
        leftMargin=2*cm, rightMargin=2*cm,
        title='AOM GT Documentation DGAC',
        author='AIR OCEAN MAROC',
    )

    story = []

    # ── COUVERTURE DGAC ────────────────────────────────────────────────────
    story.append(Spacer(1, 2*cm))

    cover = Table([
        [Paragraph('AIR OCEAN MAROC', S['cover_title'])],
        [Paragraph('Opérateur AOC N° 032 — Maroc', S['cover_meta'])],
        [Spacer(1, 6*mm)],
        [Paragraph('DOCUMENTATION TECHNIQUE', S['cover_sub'])],
        [Paragraph('SYSTÈME INFORMATIQUE DE GESTION', S['cover_sub'])],
        [Paragraph('DES MISSIONS DE TRANSPORT TERRESTRE', S['cover_sub'])],
        [Spacer(1, 8*mm)],
        [Paragraph('<b>AOM LOGISTICS — GROUND TRANSPORT MOBILE</b>', S['cover_sub'])],
        [Spacer(1, 8*mm)],
        [Paragraph(f'Réf. : AOM-GT-DOC-DGAC-001', S['cover_meta'])],
        [Paragraph(f'Issue 1 — Révision 0 — {DATE_STR}', S['cover_meta'])],
        [Paragraph('Soumis à la Direction Générale de l\'Aviation Civile du Maroc', S['cover_meta'])],
    ], colWidths=[17*cm])
    cover.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), AOM_DARK_BLUE),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 20),
        ('RIGHTPADDING', (0,0), (-1,-1), 20),
    ]))
    story.append(cover)
    story.append(Spacer(1, 8*mm))

    # Table de contrôle du document
    ctrl = [
        ['CONTRÔLE DU DOCUMENT', ''],
        ['Référence document', 'AOM-GT-DOC-DGAC-001'],
        ['Titre', 'Système Informatique de Gestion des Missions de Transport Terrestre'],
        ['Opérateur', 'AIR OCEAN MAROC (AOM)'],
        ['Numéro AOC', '032'],
        ['Issue / Révision', 'Issue 1 / Révision 0'],
        ['Date de publication', DATE_STR],
        ['Préparé par', 'Direction des Systèmes d\'Information — AOM'],
        ['Vérifié par', 'Responsable Qualité & Conformité — AOM'],
        ['Approuvé par', 'Directeur Général — AOM'],
        ['Statut', 'APPROUVÉ — Soumis à la DGAC pour information'],
        ['Base réglementaire', 'RAMC Part-ORO / Part-CAT / Circulaire DGAC IT-OPS-001'],
    ]
    t = Table(
        [[Paragraph(r[0], S['table_header'] if i==0 else S['table_cell']),
          Paragraph(r[1], S['table_header'] if i==0 else S['table_cell'])]
         for i, r in enumerate(ctrl)],
        colWidths=[6*cm, 11*cm])
    t.setStyle(TableStyle([
        ('SPAN', (0,0), (1,0)),
        ('BACKGROUND', (0,0), (1,0), AOM_RED),
        ('BACKGROUND', (0,1), (0,-1), AOM_DARK_BLUE),
        ('TEXTCOLOR', (0,0), (1,0), WHITE),
        ('TEXTCOLOR', (0,1), (0,-1), WHITE),
        ('ALIGN', (0,0), (1,0), 'CENTER'),
        ('GRID', (0,0), (-1,-1), 0.5, AOM_MID_GREY),
        ('ROWBACKGROUNDS', (1,1), (1,-1), [WHITE, AOM_LIGHT_GREY]),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('LEFTPADDING', (0,0), (-1,-1), 8),
        ('FONTSIZE', (0,0), (-1,-1), 9),
    ]))
    story.append(t)
    story.append(PageBreak())

    # ── HISTORIQUE DES RÉVISIONS ───────────────────────────────────────────
    story.append(Paragraph('HISTORIQUE DES RÉVISIONS', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1.5, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    revisions = [
        ['Issue', 'Révision', 'Date', 'Description', 'Auteur'],
        ['1', '0', DATE_STR, 'Création initiale du document — Première soumission DGAC', 'DSI AOM'],
    ]
    story.append(section_table(revisions, [1.5*cm, 1.8*cm, 2.8*cm, 9.5*cm, 2.4*cm], S))
    story.append(PageBreak())

    # ── SOMMAIRE DGAC ──────────────────────────────────────────────────────
    story.append(Paragraph('TABLE DES MATIÈRES', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1.5, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    toc_dgac = [
        ('1.', 'Objet et domaine d\'application', '4'),
        ('2.', 'Références réglementaires', '4'),
        ('3.', 'Description générale du système', '5'),
        ('4.', 'Architecture technique', '5'),
        ('5.', 'Fonctionnalités du système', '6'),
        ('6.', 'Sécurité et protection des données', '8'),
        ('7.', 'Gestion des accès et des habilitations', '8'),
        ('8.', 'Traçabilité et journalisation', '9'),
        ('9.', 'Plan de continuité et sauvegarde', '9'),
        ('10.', 'Validation et tests', '10'),
        ('11.', 'Formation des utilisateurs', '10'),
        ('12.', 'Gestion des modifications (Change Management)', '11'),
        ('13.', 'Conformité et déclarations', '11'),
        ('Annexe A', 'Inventaire des équipements et logiciels', '12'),
        ('Annexe B', 'Schéma de flux des données', '12'),
        ('Annexe C', 'Déclaration de conformité', '13'),
    ]
    for num, title, page in toc_dgac:
        row = Table([[
            Paragraph(f'<b>{num}</b>', S['body']),
            Paragraph(title, S['body']),
            Paragraph(page, S['body']),
        ]], colWidths=[1.8*cm, 13.2*cm, 2*cm])
        row.setStyle(TableStyle([
            ('ALIGN', (2,0), (2,0), 'RIGHT'),
            ('TOPPADDING', (0,0), (-1,-1), 2),
            ('BOTTOMPADDING', (0,0), (-1,-1), 2),
            ('LINEBELOW', (0,0), (-1,-1), 0.3, AOM_MID_GREY),
        ]))
        story.append(row)
    story.append(PageBreak())

    # ── 1. OBJET ───────────────────────────────────────────────────────────
    story.append(Paragraph('1. Objet et domaine d\'application', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Le présent document constitue la documentation technique du système informatique '
        '<b>AOM Logistics — Ground Transport Mobile</b>, mis en place par AIR OCEAN MAROC (AOM) '
        'pour la gestion et la traçabilité des opérations de transport terrestre des membres '
        'd\'équipage. Ce document est soumis à la Direction Générale de l\'Aviation Civile du Maroc '
        '(DGAC) conformément aux exigences de documentation des systèmes opérationnels assistés '
        'par informatique.',
        S['body']))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph('Domaine d\'application :', S['h3']))
    apps = [
        '• Transport terrestre des membres d\'équipage (pilotes, copilotes, personnel navigant technique et commercial)',
        '• Coordination entre la base opérationnelle AOM (Casablanca) et les aéroports d\'opération',
        '• Notification des équipages et des conducteurs désignés',
        '• Génération des rapports d\'activité de transport',
    ]
    for a in apps:
        story.append(Paragraph(a, S['bullet']))

    # ── 2. RÉFÉRENCES RÉGLEMENTAIRES ───────────────────────────────────────
    story.append(Paragraph('2. Références réglementaires', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    refs = [
        ['Référence', 'Document', 'Applicable'],
        ['RAMC Part-ORO', 'Règlement Aéronautique Marocain — Organisation des opérateurs', 'Oui'],
        ['RAMC Part-CAT', 'Règlement Aéronautique Marocain — Opérations de transport aérien commercial', 'Oui'],
        ['RAMC Part-CC', 'Membres d\'équipage de cabine', 'Oui'],
        ['EU-OPS (référence)', 'EU-OPS 1 — Opérations commerciales (référence adoptée)', 'Partiel'],
        ['RGPD / Loi 09-08', 'Protection des données personnelles — Loi marocaine 09-08', 'Oui'],
        ['ISO 27001', 'Sécurité des systèmes d\'information (référentiel)', 'Référence'],
        ['AOC AOM N°032', 'Certificat d\'Opérateur Aérien AOM — Conditions spéciales', 'Oui'],
    ]
    story.append(section_table(refs, [3.5*cm, 9.5*cm, 2.5*cm], S))

    # ── 3. DESCRIPTION GÉNÉRALE ────────────────────────────────────────────
    story.append(Paragraph('3. Description générale du système', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'L\'application <b>AOM Logistics Ground Transport Mobile</b> est une application native '
        'Android développée en technologie Flutter (Dart), fonctionnant en mode hors-ligne principal '
        'avec connexion internet ponctuelle pour le calcul des itinéraires. '
        'Elle remplace les processus manuels (appels téléphoniques, SMS, feuilles de route papier) '
        'par un système numérique traçable et sécurisé.',
        S['body']))
    story.append(Spacer(1, 3*mm))

    desc = [
        ['Critère', 'Valeur'],
        ['Nom du système', 'AOM Logistics — Ground Transport Mobile'],
        ['Version logicielle', '1.0.0+1'],
        ['Plateforme', 'Android 8.0 (API 26) et supérieur'],
        ['Technologie', 'Flutter 3.44 / Dart / SQLite (Drift ORM)'],
        ['Type de déploiement', 'APK distribué en interne (side-loading)'],
        ['Mode de fonctionnement', 'Hors-ligne principal / Connexion ponctuelle'],
        ['Données', 'Stockage local SQLite — aucun serveur cloud propriétaire'],
        ['Utilisateurs', 'Personnel de la Direction des Opérations AOM'],
    ]
    story.append(section_table(desc, [6*cm, 11*cm], S))

    # ── 4. ARCHITECTURE TECHNIQUE ──────────────────────────────────────────
    story.append(Paragraph('4. Architecture technique', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('4.1 Composants logiciels', S['h2']))
    comps = [
        ['Composant', 'Technologie / Version', 'Rôle'],
        ['Application mobile', 'Flutter 3.44 / Dart 3.x', 'Interface utilisateur et logique métier'],
        ['Base de données locale', 'SQLite via Drift ORM v2.14', 'Persistance de toutes les données'],
        ['Calcul d\'itinéraires', 'API OSRM (router.project-osrm.org)', 'Distances routières réelles'],
        ['Cartographie', 'Flutter Map + OpenStreetMap', 'Affichage cartes et sélection GPS'],
        ['Notifications push', 'flutter_local_notifications v17', 'Rappels avant mission'],
        ['Navigation Maps', 'Google Maps (lien externe)', 'Itinéraire chauffeur'],
        ['Messagerie', 'WhatsApp (lien externe wa.me)', 'Notifications équipages'],
        ['Export PDF', 'pdf / printing packages', 'Rapports d\'activité'],
        ['Gestion état', 'Riverpod v2.5', 'State management réactif'],
    ]
    story.append(section_table(comps, [4*cm, 5*cm, 8*cm], S))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('4.2 Flux de données externes', S['h2']))
    flux = [
        ['Service externe', 'Données transmises', 'Données reçues', 'Chiffrement'],
        ['OSRM (OpenStreetMap)', 'Coordonnées GPS waypoints', 'Distances + durées en secondes', 'HTTPS TLS 1.3'],
        ['Google Maps (lien)', 'Coordonnées dans URL', 'Application Maps native', 'HTTPS'],
        ['WhatsApp (wa.me)', 'Numéro + message encodé URL', 'Application WA native', 'HTTPS'],
    ]
    story.append(section_table(flux, [3.5*cm, 4.5*cm, 4.5*cm, 4.5*cm], S))
    story.append(info_box(
        '<b>Conformité données :</b> Aucune donnée personnelle (noms, numéros de téléphone) '
        'n\'est transmise aux services externes OSRM. Seules les coordonnées GPS anonymisées '
        'sont utilisées pour le calcul d\'itinéraires.',
        S, color=colors.HexColor('#E3F2FD'), border=AOM_DARK_BLUE))

    story.append(PageBreak())

    # ── 5. FONCTIONNALITÉS ─────────────────────────────────────────────────
    story.append(Paragraph('5. Fonctionnalités du système', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('5.1 Gestion des ressources opérationnelles', S['h2']))
    story.append(Paragraph(
        'Le système maintient un registre numérique des ressources impliquées dans les '
        'opérations de transport terrestre AOM :',
        S['body']))

    ressources = [
        ['Module', 'Données gérées', 'Actions'],
        ['Chauffeurs', 'Nom, téléphone, statut actif', 'CRUD complet + désactivation logique'],
        ['Véhicules', 'Marque, immatriculation, capacité, statut', 'CRUD complet + désactivation logique'],
        ['Équipages / Passagers', 'Nom, fonction, téléphone, ville, GPS domicile', 'CRUD complet + position GPS'],
        ['Destinations', 'Nom, code OACI, ville, coordonnées GPS, type', 'CRUD complet + statut aéroport'],
    ]
    story.append(section_table(ressources, [3.5*cm, 6*cm, 7.5*cm], S))

    story.append(Paragraph('5.2 Planification des missions', S['h2']))
    story.append(Paragraph(
        'Une <b>mission</b> représente un trajet de transport organisé. Elle associe un chauffeur, '
        'un véhicule, une liste de passagers avec leurs points de prise en charge, et une destination finale.',
        S['body']))

    mission_fields = [
        ['Données de mission', 'Description réglementaire'],
        ['Référence unique', 'Identifiant traçable format AOM-AAAA-NNN (ex: AOM-2026-352)'],
        ['Type DÉPART/ARRIVÉE', 'Sens du transport par rapport au vol associé'],
        ['Date/heure planifiée', 'Horodatage UTC de la mission'],
        ['Chauffeur assigné', 'Conducteur désigné avec traçabilité de l\'affectation'],
        ['Véhicule assigné', 'Immatriculation et capacité du véhicule'],
        ['Liste des passagers', 'Membres d\'équipage avec points de pickup individuels'],
        ['Itinéraire calculé', 'Séquence ordonnée des stops avec distances OSRM'],
        ['Statut', 'PLANIFIÉE / EN_COURS / TERMINÉE / ANNULÉE'],
        ['Notes opérationnelles', 'Informations contextuelles libres'],
    ]
    story.append(section_table(mission_fields, [5*cm, 12*cm], S))

    story.append(Paragraph('5.3 Calcul d\'itinéraires', S['h2']))
    story.append(Paragraph(
        'Le système utilise l\'API <b>OSRM (Open Source Routing Machine)</b> basée sur les données '
        'cartographiques OpenStreetMap pour calculer :\n'
        '• Les distances routières réelles entre chaque point de passage\n'
        '• Les durées estimées de chaque tronçon (en minutes)\n'
        '• La distance totale de la mission\n'
        '• La durée totale estimée\n\n'
        'En cas d\'indisponibilité réseau, le calcul bascule automatiquement sur la formule '
        'Haversine (distance à vol d\'oiseau × coefficient routier 1.25) avec notification '
        'transparente de l\'estimation.',
        S['body']))

    story.append(Paragraph('5.4 Système de notification des équipages', S['h2']))
    story.append(Paragraph(
        'L\'application génère des messages de convocation personnalisés via WhatsApp. '
        'Chaque notification est journalisée dans le système avec son statut (GÉNÉRÉ / '
        'OUVERT_WHATSAPP / MARQUÉ_ENVOYÉ). Ces journaux constituent une trace '
        'opérationnelle de la communication avec les équipages.',
        S['body']))
    story.append(Spacer(1, 2*mm))

    notif_process = [
        ['Étape', 'Action système', 'Trace générée'],
        ['1', 'Génération du message personnalisé (chauffeur ou passager)', 'Message en base de données'],
        ['2', 'Ouverture WhatsApp via URL wa.me', 'Statut OUVERT_WHATSAPP + horodatage'],
        ['3', 'Confirmation manuelle d\'envoi par l\'opérateur', 'Statut MARQUÉ_ENVOYÉ + horodatage'],
    ]
    story.append(section_table(notif_process, [1.5*cm, 8*cm, 7.5*cm], S))

    # ── 6. SÉCURITÉ DONNÉES ────────────────────────────────────────────────
    story.append(Paragraph('6. Sécurité et protection des données', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('6.1 Stockage des données', S['h2']))
    story.append(Paragraph(
        'Toutes les données opérationnelles sont stockées dans une base de données <b>SQLite</b> '
        'locale sur l\'appareil mobile désigné. La base est protégée par le système de sécurité '
        'Android (chiffrement des données de l\'application au niveau du système d\'exploitation).',
        S['body']))

    story.append(Paragraph('6.2 Données personnelles (Loi 09-08)', S['h2']))
    data_perso = [
        ['Catégorie de données', 'Finalité', 'Durée de conservation'],
        ['Noms des membres d\'équipage', 'Identification dans les missions', 'Durée d\'activité + 1 an'],
        ['Numéros de téléphone', 'Notification WhatsApp', 'Durée d\'activité + 1 an'],
        ['Coordonnées GPS domicile', 'Optimisation des itinéraires de ramassage', 'Durée d\'activité'],
        ['Historique des missions', 'Traçabilité opérationnelle', '3 ans (archive)'],
        ['Logs de notifications', 'Audit et conformité', '1 an'],
    ]
    story.append(section_table(data_perso, [4.5*cm, 6*cm, 6.5*cm], S))
    story.append(Spacer(1, 3*mm))
    story.append(info_box(
        '<b>Base légale (Loi 09-08) :</b> Le traitement des données personnelles des membres '
        'd\'équipage est fondé sur l\'exécution du contrat de travail et les obligations légales '
        'de l\'opérateur aérien. Les personnes concernées ont été informées conformément à '
        'l\'article 4 de la Loi 09-08.',
        S, color=colors.HexColor('#FFF9C4'), border=AOM_GOLD))

    story.append(Paragraph('6.3 Verrouillage de l\'application', S['h2']))
    story.append(Paragraph(
        'L\'application dispose d\'une fonctionnalité de verrouillage par code PIN (4 à 6 chiffres) '
        'configurable dans les paramètres. Ce PIN est stocké localement et protège l\'accès '
        'à toutes les fonctionnalités de l\'application.',
        S['body']))

    # ── 7. ACCÈS ET HABILITATIONS ──────────────────────────────────────────
    story.append(Paragraph('7. Gestion des accès et des habilitations', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph(
        'L\'application est actuellement déployée en mode <b>mono-utilisateur</b> sur un appareil '
        'dédié à la Direction des Opérations. L\'accès est contrôlé par :\n'
        '1. Le verrouillage natif de l\'appareil Android (biométrie + code)\n'
        '2. Le PIN applicatif optionnel (4-6 chiffres)\n'
        '3. La distribution contrôlée de l\'APK (usage interne uniquement)',
        S['body']))
    story.append(Spacer(1, 3*mm))

    habilitations = [
        ['Profil', 'Accès', 'Actions autorisées'],
        ['Opérateur Ops (principal)', 'Complet', 'Toutes les fonctionnalités'],
        ['Superviseur (consultation)', 'Limité', 'Consultation missions + rapports PDF'],
        ['Maintenance IT', 'Technique', 'Export sauvegarde + réinitialisation données'],
    ]
    story.append(section_table(habilitations, [4.5*cm, 2.5*cm, 10*cm], S))

    # ── 8. TRAÇABILITÉ ─────────────────────────────────────────────────────
    story.append(Paragraph('8. Traçabilité et journalisation', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Le système enregistre automatiquement les informations suivantes pour assurer '
        'la traçabilité complète des opérations :',
        S['body']))

    traces = [
        ['Événement tracé', 'Données journalisées'],
        ['Création de mission', 'Référence, horodatage, utilisateur, paramètres complets'],
        ['Modification de mission', 'Nature de la modification, horodatage updatedAt'],
        ['Changement de statut', 'Nouveau statut, horodatage, statut précédent'],
        ['Envoi notification WhatsApp', 'Destinataire, numéro, message, statut, horodatages ouverture et envoi'],
        ['Ajout / suppression d\'étape', 'Type d\'étape, coordonnées, recalcul distances'],
        ['Suppression de mission', 'Référence supprimée, horodatage (suppression définitive)'],
    ]
    story.append(section_table(traces, [5.5*cm, 11.5*cm], S))

    # ── 9. CONTINUITÉ ET SAUVEGARDE ────────────────────────────────────────
    story.append(PageBreak())
    story.append(Paragraph('9. Plan de continuité et sauvegarde', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph('9.1 Sauvegarde des données', S['h2']))
    story.append(Paragraph(
        'L\'application dispose d\'une fonction d\'export manuel de toutes les données '
        'au format JSON structuré. Cette sauvegarde inclut : missions, chauffeurs, véhicules, '
        'passagers, destinations, paramètres et logs de notifications.',
        S['body']))

    sauvegarde = [
        ['Procédure', 'Fréquence recommandée', 'Stockage'],
        ['Export JSON manuel', 'Hebdomadaire (chaque lundi)', 'Google Drive AOM + email DSI'],
        ['Sauvegarde appareil Android', 'Automatique via Google Backup', 'Google Account AOM'],
        ['Archive missions PDF', 'Mensuelle', 'Serveur interne AOM'],
    ]
    story.append(section_table(sauvegarde, [5*cm, 5.5*cm, 6.5*cm], S))

    story.append(Paragraph('9.2 Continuité opérationnelle', S['h2']))
    story.append(Paragraph(
        'En cas de défaillance de l\'application ou de l\'appareil, les procédures alternatives '
        'suivantes sont applicables :',
        S['body']))
    conti = [
        '• <b>Panne réseau :</b> L\'application fonctionne entièrement hors-ligne. '
          'Seul le calcul OSRM utilise le réseau (fallback Haversine automatique).',
        '• <b>Panne appareil :</b> Réinstallation APK sur appareil de remplacement + '
          'restauration depuis dernière sauvegarde JSON (max 7 jours de données).',
        '• <b>Procédure manuelle :</b> Retour aux formulaires papier "Feuille de Route Équipage" '
          '(AOM-OPS-FR-002) en attente de remise en service du système.',
    ]
    for c in conti:
        story.append(Paragraph(c, S['bullet']))

    # ── 10. VALIDATION ET TESTS ────────────────────────────────────────────
    story.append(Paragraph('10. Validation et tests', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    tests = [
        ['Test', 'Méthode', 'Résultat', 'Date'],
        ['Fonctionnement général', 'Tests manuels sur Samsung Galaxy S22', 'RÉUSSI', DATE_STR],
        ['Calcul distances OSRM', 'Vérification sur trajets Casablanca-Benslimane', 'RÉUSSI', DATE_STR],
        ['Notifications WhatsApp', 'Envoi test chauffeur + 3 passagers', 'RÉUSSI', DATE_STR],
        ['Notifications push', 'Rappel planifié 15 min + réception', 'RÉUSSI', DATE_STR],
        ['Export PDF rapport', 'Génération avec filtres période/chauffeur', 'RÉUSSI', DATE_STR],
        ['Sauvegarde données', 'Export JSON + vérification intégrité', 'RÉUSSI', DATE_STR],
        ['Fonctionnement hors-ligne', 'Mode avion — toutes fonctions locales', 'RÉUSSI', DATE_STR],
        ['Paramétrage base départ', 'Modification et persistance', 'RÉUSSI', DATE_STR],
        ['Sécurité PIN', 'Activation + verrouillage + déverrouillage', 'RÉUSSI', DATE_STR],
    ]
    story.append(section_table(tests, [4.5*cm, 5.5*cm, 2.5*cm, 2.5*cm], S))

    # ── 11. FORMATION ──────────────────────────────────────────────────────
    story.append(Paragraph('11. Formation des utilisateurs', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    story.append(Paragraph(
        'La mise en service du système inclut les actions de formation suivantes :',
        S['body']))

    formation = [
        ['Action de formation', 'Durée', 'Participants', 'Support'],
        ['Formation initiale opérateurs', '2 heures', 'Personnel Opérations (2 personnes)', 'Manuel Utilisateur AOM-GT-MU-001'],
        ['Formation administrateur IT', '1 heure', 'DSI AOM (1 personne)', 'Documentation technique'],
        ['Exercice pratique supervisé', '30 min', 'Opérateurs + superviseur', 'Scénarios test'],
        ['Formation recyclage', 'Annuelle ou à chaque mise à jour majeure', 'Tous utilisateurs', 'Notes de version'],
    ]
    story.append(section_table(formation, [4.5*cm, 2.5*cm, 5*cm, 5*cm], S))

    # ── 12. CHANGE MANAGEMENT ──────────────────────────────────────────────
    story.append(Paragraph('12. Gestion des modifications (Change Management)', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'Toute modification du système (mise à jour fonctionnelle, correctif, changement de configuration) '
        'suivra le processus de gestion des changements AOM :',
        S['body']))

    cm_steps = [
        '1. <b>Demande de changement</b> formalisée par la Direction des Opérations',
        '2. <b>Analyse d\'impact</b> par la Direction des Systèmes d\'Information',
        '3. <b>Approbation</b> du Responsable Qualité & Conformité',
        '4. <b>Tests de validation</b> sur environnement de qualification',
        '5. <b>Déploiement</b> avec notification de la DGAC si changement significatif',
        '6. <b>Mise à jour</b> de la présente documentation (nouvelle révision)',
        '7. <b>Formation</b> des utilisateurs si nécessaire',
    ]
    for s in cm_steps:
        story.append(Paragraph(s, S['bullet']))

    story.append(Spacer(1, 3*mm))
    story.append(info_box(
        '<b>Critères de notification DGAC :</b> Tout changement affectant les fonctionnalités '
        'de traçabilité, de sécurité des données, ou le processus de notification des équipages '
        'fera l\'objet d\'une soumission d\'une nouvelle révision de ce document à la DGAC.',
        S, color=colors.HexColor('#FFF9C4'), border=AOM_GOLD))

    # ── 13. CONFORMITÉ ─────────────────────────────────────────────────────
    story.append(Paragraph('13. Conformité et déclarations', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))
    story.append(Paragraph(
        'AIR OCEAN MAROC déclare que le système <b>AOM Logistics — Ground Transport Mobile</b> :\n\n'
        '1. Ne se substitue pas aux documents opérationnels réglementaires (MEL, FCOM, OPS Manual)\n'
        '2. Est un outil d\'aide à la coordination opérationnelle, sans caractère certifié aviation\n'
        '3. N\'intervient pas dans les processus de certification ou d\'entretien des aéronefs\n'
        '4. Est soumis à l\'audit de la DGAC à première demande\n'
        '5. Fait l\'objet d\'une revue annuelle de conformité par le Responsable Qualité AOM',
        S['body']))

    story.append(PageBreak())

    # ── ANNEXE A ───────────────────────────────────────────────────────────
    story.append(Paragraph('Annexe A — Inventaire des équipements et logiciels', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    inventaire = [
        ['Composant', 'Référence / Version', 'Licence', 'Fournisseur'],
        ['Framework Flutter', '3.44.0 stable', 'BSD 3-Clause', 'Google'],
        ['Langage Dart', '3.x', 'BSD 3-Clause', 'Google'],
        ['Base de données Drift (SQLite ORM)', '2.14.1', 'MIT', 'Simon Binder'],
        ['SQLite natif Android', '3.x', 'Domaine public', 'D. Richard Hipp'],
        ['Calcul distances OSRM', 'Service public gratuit', 'Open Database License', 'OSRM Project'],
        ['Cartographie flutter_map', '7.0.2', 'BSD', 'Dart/Flutter community'],
        ['OpenStreetMap', 'Tuiles cartographiques', 'ODbL', 'OpenStreetMap Foundation'],
        ['Notifications flutter_local_notifications', '17.2.4', 'BSD', 'MaikuB'],
        ['Gestion état Riverpod', '2.5.1', 'MIT', 'Remi Rousselet'],
        ['Export PDF (pdf/printing)', '3.10.8 / 5.12.0', 'Apache 2.0', 'David PHAM-VAN'],
        ['Navigation GoRouter', '13.2.0', 'BSD', 'Google'],
        ['Appareil mobile', 'Samsung Galaxy S22 (SM-S908E)', 'N/A', 'Samsung'],
        ['Système d\'exploitation', 'Android 16 (API 36)', 'Apache 2.0', 'Google'],
    ]
    story.append(section_table(inventaire, [4.5*cm, 3.5*cm, 3*cm, 6*cm], S))

    # ── ANNEXE B ───────────────────────────────────────────────────────────
    story.append(Paragraph('Annexe B — Schéma de flux des données', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 3*mm))

    schema = [
        ['Acteur / Système', 'Direction', 'Données échangées'],
        ['Opérateur AOM', '→ Application', 'Saisie missions, paramètres, équipages'],
        ['Application', '→ Base SQLite locale', 'Persistance toutes données'],
        ['Application', '→ OSRM (HTTPS)', 'Coordonnées GPS waypoints (anonymes)'],
        ['OSRM', '→ Application', 'Distances (mètres), durées (secondes)'],
        ['Application', '→ Google Maps (URL)', 'Coordonnées tous stops dans URL'],
        ['Application', '→ WhatsApp (URL wa.me)', 'Message encodé + numéro destinataire'],
        ['Application', '→ Système Android', 'Planification notification push locale'],
        ['Système Android', '→ Utilisateur', 'Affichage notification 15 min avant mission'],
        ['Application', '→ Fichier JSON', 'Export sauvegarde (manuel)'],
    ]
    story.append(section_table(schema, [4.5*cm, 2.5*cm, 10*cm], S))

    # ── ANNEXE C — DÉCLARATION CONFORMITÉ ─────────────────────────────────
    story.append(Paragraph('Annexe C — Déclaration de conformité', S['h1']))
    story.append(HRFlowable(width='100%', thickness=1, color=AOM_RED))
    story.append(Spacer(1, 6*mm))

    decl = Table([[Paragraph(
        'Je soussigné, Directeur Général d\'AIR OCEAN MAROC, déclare que le système '
        '<b>AOM Logistics — Ground Transport Mobile (Version 1.0.0)</b> a été développé, '
        'testé et déployé conformément aux exigences opérationnelles et réglementaires '
        'applicables à nos opérations de transport aérien commercial.\n\n'
        'Ce système est mis en œuvre comme outil d\'aide à la coordination opérationnelle '
        'des équipages. Il n\'est pas un système certifié aviation au sens des régulations '
        'techniques aéronautiques, mais constitue un outil informatique de gestion interne '
        'soumis aux exigences de qualité et de traçabilité de notre SGS (Système de Gestion '
        'de la Sécurité).\n\n'
        'Nous nous engageons à notifier la DGAC de toute modification substantielle '
        'du système et à maintenir ce document à jour.',
        S['body'])]], colWidths=[17*cm])
    decl.setStyle(TableStyle([
        ('BOX', (0,0), (-1,-1), 1, AOM_DARK_BLUE),
        ('TOPPADDING', (0,0), (-1,-1), 12),
        ('BOTTOMPADDING', (0,0), (-1,-1), 12),
        ('LEFTPADDING', (0,0), (-1,-1), 14),
        ('RIGHTPADDING', (0,0), (-1,-1), 14),
        ('BACKGROUND', (0,0), (-1,-1), AOM_LIGHT_GREY),
    ]))
    story.append(decl)
    story.append(Spacer(1, 1*cm))

    sign_data = [
        ['', 'Casablanca, le ' + DATE_STR, ''],
        ['', '', ''],
        ['', '______________________________', ''],
        ['', 'Directeur Général', ''],
        ['', 'AIR OCEAN MAROC', ''],
        ['', 'AOC N° 032', ''],
    ]
    sign_t = Table(sign_data, colWidths=[4*cm, 9*cm, 4*cm])
    sign_t.setStyle(TableStyle([
        ('ALIGN', (1,0), (1,-1), 'CENTER'),
        ('FONTNAME', (1,0), (1,0), 'Helvetica'),
        ('FONTSIZE', (1,0), (1,-1), 10),
    ]))
    story.append(sign_t)
    story.append(Spacer(1, 1*cm))
    story.append(HRFlowable(width='100%', thickness=0.5, color=AOM_MID_GREY))
    story.append(Spacer(1, 4*mm))
    story.append(Paragraph(
        '<i>Document propriété exclusive d\'AIR OCEAN MAROC. '
        'Reproduction et diffusion soumises à autorisation écrite de la Direction. '
        'Référence : AOM-GT-DOC-DGAC-001 — Issue 1 Rev 0 — ' + DATE_STR + '</i>',
        S['note']))

    doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
    print(f'[OK] Documentation DGAC : {path}')
    return path


if __name__ == '__main__':
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print('Génération des manuels AOM Ground Transport...')
    p1 = build_user_manual()
    p2 = build_dgac_manual()
    print(f'\nFichiers générés :')
    print(f'  1. {p1}')
    print(f'  2. {p2}')
