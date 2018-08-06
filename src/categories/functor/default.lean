-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Tim Baumann, Stephen Morgan, Scott Morrison

import ..category
import ..tactics

namespace category_theory
 
universes u₁ v₁ u₂ v₂ u₃ v₃

structure Functor (C : Type u₁) [category.{u₁ v₁} C] (D : Type u₂) [category.{u₂ v₂} D] : Type (max u₁ v₁ u₂ v₂) :=
(onObjects     : C → D)
(onMorphisms   : Π {X Y : C}, (X ⟶ Y) → ((onObjects X) ⟶ (onObjects Y)))
(identities    : ∀ (X : C), onMorphisms (𝟙 X) = 𝟙 (onObjects X) . obviously)
(functoriality : ∀ {X Y Z : C} (f : X ⟶ Y) (g : Y ⟶ Z), onMorphisms (f ≫ g) = (onMorphisms f) ≫ (onMorphisms g) . obviously)

make_lemma Functor.identities
make_lemma Functor.functoriality
attribute [simp,ematch] Functor.functoriality_lemma Functor.identities_lemma

infixr ` +> `:70 := Functor.onObjects
infixr ` &> `:70 := Functor.onMorphisms -- switch to ▹?
infixr ` ↝ `:70 := Functor -- type as \lea 

namespace Functor

instance {C : Type u₁} [category.{u₁ v₁} C] {D : Type u₂} [category.{u₂ v₂} D] : has_coe_to_fun (C ↝ D) :=
{ F   := λ F, C → D,
  coe := λ F, F.onObjects }

@[simp] lemma unfold_coercion {C : Type u₁} [category.{u₁ v₁} C] {D : Type u₂} [category.{u₂ v₂} D] (F : C ↝ D) (X : C) : F X = F +> X := rfl

definition id (C : Type u₁) [category.{u₁ v₁} C] : C ↝ C := 
{ onObjects     := id,
  onMorphisms   := λ _ _ f, f,
  identities    := begin 
                     -- `obviously'` says:
                     intros,
                     refl 
                   end,
  functoriality := begin
                     -- `obviously'` says:
                     intros,
                     refl
                   end }

instance (C) [category C] : has_one (C ↝ C) :=
{ one := id C }

section
variable {C : Type u₁}
variable [𝒞 : category.{u₁ v₁} C]
include 𝒞

@[simp] lemma id.onObjects (X : C) : (id C) +> X = X := rfl
@[simp] lemma id.onMorphisms {X Y : C} (f : X ⟶ Y) : (id C) &> f = f := rfl
end

section
variable {C : Type u₁}
variable [𝒞 : category.{u₁ v₁} C]
variable {D : Type u₂}
variable [𝒟 : category.{u₂ v₂} D]
variable {E : Type u₃}
variable [ℰ : category.{u₃ v₃} E]
include 𝒞 𝒟 ℰ

definition comp (F : C ↝ D) (G : D ↝ E) : C ↝ E := 
{ onObjects     := λ X, G +> (F +> X),
  onMorphisms   := λ _ _ f, G &> (F &> f),
  identities    := begin 
                     -- `obviously'` says:
                     intros,
                     simp at *,
                   end,
  functoriality := begin
                     -- `obviously'` says:
                     intros,
                     simp at *
                   end }
infixr ` ⋙ `:80 := comp

@[simp] lemma comp.onObjects (F : C ↝ D) (G : D ↝ E) (X : C) : (F ⋙ G) X = G (F X) := rfl
@[simp] lemma comp.onMorphisms (F : C ↝ D) (G : D ↝ E) (X Y: C) (f : X ⟶ Y) : (F ⋙ G) &> f = G.onMorphisms (F &> f) := rfl
end
end Functor

end category_theory
