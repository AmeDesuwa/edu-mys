# Chapter 3: The Broken Sculpture

## Theme/Lesson: "Creativity & Envy"
- True creativity comes from expressing yourself, not proving yourself better than others
- Envy destroys both the envious and what they envy

## Setting
Art Week at school. The courtyard displays student sculptures and artwork.

## Characters

### Returning
- **Conrad** - Main detective protagonist
- **Mark** - Conrad's partner
- **Diwata Laya** - Mystical guide
- **B.C.** - Mystery figure (leaves card at end)

### New Characters (Need portraits)
- **Mia** - The sculptor whose work was destroyed. Talented, humble, recently won the regional art competition
- **Victor** - Fellow art student, technically skilled but always second place to Mia. Bitter about never being recognized
- **Ms. Reyes** - Art teacher, adviser for Art Week

### Background Characters (mentioned but no portrait needed)
- **Art club members** - Witnesses
- **Principal** - Brief appearance

---

## Scene Breakdown

### c3s0 - Prologue: The Night Before (No player interaction)
**Background:** art_room.png or courtyard_night.png

The night before Art Week opening. A figure enters the courtyard where the sculptures are displayed.
- Show the sculpture: "The Reader" - a beautiful clay figure of a student reading under a tree
- The figure hesitates, hands trembling
- Internal conflict visible - they don't want to do this but feel compelled
- The crash of the sculpture breaking
- The figure flees, dropping something small

**Purpose:** Build mystery, show the crime without revealing culprit

---

### c3s1 - Discovery
**Background:** courtyard.png → hallway.png

Art Week morning. Students gather for the exhibit opening.
- Conrad and Mark arrive, discussing the art displays
- Sudden commotion near the main exhibit
- They discover the shattered sculpture
- Mia is devastated - it was her award-winning piece
- A small note is found on the pedestal: "Not everyone deserves to shine"

**Introduces:**
- Mia (victim)
- The mystery
- First clue (the note)

---

### c3s2 - Investigation & Interviews
**Background:** courtyard.png → art_room.png → hallway.png

Conrad and Mark investigate:
- Examine the scene: broken sculpture, note, something dropped (a paint-stained cloth)
- Interview Mia: Learn about her recent competition win, the sculpture's meaning (made it for her late grandfather who encouraged her art)
- Interview Victor: He's defensive, mentions he was at home, dismissive of Mia's "overrated" work
- Interview Ms. Reyes: Reveals tension between Victor and Mia, mentions Victor's sculpture was passed over for the exhibit

**Laya appears:** Senses strong jealousy imprinted on the note. Guides Conrad.

**Player choice:** Who to focus investigation on?
- Ms. Reyes (wrong - no motive)
- An outsider vandal (wrong - note suggests personal knowledge)
- Victor (correct - motive and knowledge)

---

### c3s3 - Gathering Evidence
**Background:** art_room.png → storage_room.png

Conrad searches for concrete evidence:
- Checks Victor's art supplies - finds paint-stained cloths matching the one at the scene
- Discovers Victor's sketchbook - full of angry drawings, one shows Mia's sculpture crossed out
- Finds receipt showing Victor bought supplies at 8 PM the night before (placing him near school)

**Minigame:** Educational puzzle about art/creativity (vocabulary or art terms)

**Player choice:** What evidence is most conclusive?
- The sketchbook drawings (wrong - could be explained as artistic expression)
- The receipt timing (wrong - circumstantial)
- The matching paint cloth (correct - physical evidence at the scene)

---

### c3s4 - Confrontation
**Background:** courtyard.png

Conrad confronts Victor with the evidence:
- Victor initially denies everything
- Laya appears to Conrad privately, senses his guilt and pain
- Conrad presents the paint cloth evidence
- Victor breaks down and confesses

**Victor's confession:**
- He's always been second to Mia, even though he practices more
- His parents compare him unfavorably to her
- He didn't want to hurt the sculpture, he wanted to hurt his own feelings of inadequacy
- "I thought if her work was gone, people would finally see mine"

---

### c3s5 - Resolution & Consequences
**Background:** art_room.png

Victor faces consequences:
- Ms. Reyes is disappointed but understanding
- Victor will help restore what he can and do community service
- He apologizes to Mia

Mia's response:
- She's hurt but shows compassion
- Reveals she always admired Victor's technical skill
- "Destroying my art didn't make yours better. It just destroyed something beautiful."

---

### c3s6 - Epilogue & B.C. Card
**Background:** courtyard.png

Days later. The Art Week continues, with a collaborative piece in place of the broken sculpture.
- Conrad and Mark reflect on the case
- Find another B.C. card

**B.C. Card reads:**
"Lesson 3: Creativity"
"True artists create to express, not to compete."
"Envy sees another's light and tries to extinguish it, not realizing it could have warmed them both."
"Well done, detectives. The chain continues."
Signed: B.C.

**Laya's insight:** B.C. continues to guide them. Each lesson builds toward something.

**Level up:** Conrad reaches level 5 (if starting at 4)

**Reflection dialogue:**
- Conrad: "Victor had real talent. But he was so focused on being better than Mia that he forgot to be the best version of himself."
- Mark: "Competition can push you forward. But when it becomes about tearing others down..."
- Conrad: "That's when it stops being about the art and starts being about the ego."

---

## Assets Needed

### Backgrounds (Can reuse or simple variations)
- courtyard.png - Outdoor school area with art displays
- art_room.png - Art classroom with supplies, easels (or reuse existing classroom)
- storage_room.png - Optional, could use existing hallway

### Character Portraits
- Mia (half) - Artistic-looking student, kind expression
- Victor (half) - Intense, brooding, technically precise look
- Ms. Reyes (half) - Art teacher, creative/casual appearance

### Simplification Options
If assets are difficult:
- Reuse existing backgrounds (faculty_room as art_room, hallway for most scenes)
- Keep new characters minimal (could even have Victor described rather than shown until confrontation)
- Focus on dialogue over visuals

---

## Minigame Integration Points

1. **c3s3:** Educational minigame about art vocabulary or color theory
   - Could use fill-in-the-blank: "Primary colors are red, [blue], and [yellow]"
   - Or art terms: "A [sketch] is a rough drawing, while a [portrait] depicts a person"

2. **Optional c3s2:** Observation minigame at crime scene

---

## Variables to Track
```
set {chapter3_score} = 0
set {c3s2_reyes_tried} = false
set {c3s2_outsider_tried} = false
set {c3s3_sketchbook_tried} = false
set {c3s3_receipt_tried} = false
```

---

## Tone Notes

- Keep investigation methodical like Chapters 1-2
- Victor is sympathetic villain - driven by pain, not malice
- Emphasize that creativity should uplift, not compete destructively
- Laya provides mystical insight but Conrad solves through logic
- B.C. mystery continues to deepen
