#include QMK_KEYBOARD_H
#include "keymap_us_international.h"

#define _QWERTY 0
#define _LOWER 1
#define _RAISE 2
#define _ADJUST 16

enum custom_keycodes
{
  QWERTY = SAFE_RANGE,
  LOWER,
  RAISE,
  ADJUST,
};

#define EISU LALT(US_GRV)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_QWERTY] = LAYOUT_3key_2us(
        KC_GRV, US_1, US_2, US_3, US_4, US_5, KC_PSCR, US_MINS, US_6, US_7, US_8, US_9, US_0, US_EQL,
        KC_TAB, US_Q, US_W, US_E, US_R, US_T, US_LBRC, US_RBRC, US_Y, US_U, US_I, US_O, US_P, US_ARNG,
        KC_ESC, US_A, US_S, US_D, US_F, US_G, US_COMM, US_DOT, US_H, US_J, US_K, US_L, US_P, US_ADIA,
        KC_LSFT, US_Z, US_X, US_C, US_V, US_B, US_N, US_M, US_SCLN, KC_QUOT, KC_SLSH, KC_BSLS,
        KC_LCTL, KC_LGUI, KC_LALT, KC_RALT, LOWER, KC_SPC, KC_DEL, KC_BSPC, KC_ENT, RAISE, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT),
    [_LOWER] = LAYOUT_3key_2us(
        KC_NO, KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_F12, US_UNDS, KC_F6, KC_F7, KC_F8, KC_F9, KC_F10, KC_F11,
        KC_TILD, US_EXLM, US_AT, US_HASH, US_DLR, US_PERC, US_LCBR, US_RCBR, US_CIRC, US_AMPR, US_ASTR, US_LPRN, US_RPRN, US_PLUS,
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_LT, KC_GT, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, KC_NO, KC_NO,
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_COLN, KC_DQUO, KC_QUES, KC_PIPE,
        KC_NO, KC_NO, KC_NO, KC_NO, LOWER, KC_F13, KC_F14, KC_F15, KC_F16, RAISE, KC_MRWD, KC_VOLD, KC_VOLU, KC_MFFD),
    [_RAISE] = LAYOUT_3key_2us(
        KC_NO, KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_F12, US_UNDS, KC_F6, KC_F7, KC_F8, KC_F9, KC_F10, KC_F11,
        US_TILD, US_EXLM, US_AT, US_HASH, US_DLR, US_PERC, US_LCBR, US_RCBR, US_CIRC, US_AMPR, US_ASTR, US_LPRN, US_RPRN, US_PLUS,
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_LT, KC_GT, KC_LEFT, KC_DOWN, KC_UP, KC_RGHT, KC_NO, KC_NO,
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, US_COLN, US_DQUO, US_QUES, US_PIPE,
        KC_NO, KC_NO, KC_NO, KC_NO, LOWER, KC_F13, KC_F14, KC_F15, KC_F16, RAISE, KC_MRWD, KC_VOLD, KC_VOLU, KC_MFFD),
    [_ADJUST] = LAYOUT_3key_2us(
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO,
        KC_NO, RESET, RGB_TOG, RGB_MOD, RGB_HUD, RGB_HUI, KC_NO, KC_NO, RGB_SAD, RGB_SAI, RGB_VAD, RGB_VAI, KC_NO, KC_NO, KC_NO, KC_NO, BL_TOGG, BL_STEP, BL_DEC, BL_INC, KC_NO, KC_NO,
        KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO, KC_NO)};


#ifdef AUDIO_ENABLE
    float tone_qwerty[][2] = SONG(QWERTY_SOUND);
#endif

void persistent_default_layer_set(uint16_t default_layer)
{
  eeconfig_update_default_layer(default_layer);
  default_layer_set(default_layer);
}

// bool register_on_shift(uint16_t keycode)
// {
//   if (get_mods() == (MOD_BIT(US_LSHIFT) | MOD_BIT(US_RSHIFT)))
//   {
//     register_code(keycode) return false;
//   }
// }

bool process_record_user(uint16_t keycode, keyrecord_t *record)
{
  switch (keycode)
  {
  // case ALTGR(US_w): 
  //   if (register_on_shift(ALTGR(US_W)))
  //   {
  //     return false;
  //   }
  //   break;
  case QWERTY:
    if (record->event.pressed)
    {
      print("mode just switched to qwerty and this is a huge string\n");
      set_single_persistent_default_layer(_QWERTY);
    }
    return false;
    break;
  case LOWER:
    if (record->event.pressed)
    {
      layer_on(_LOWER);
      update_tri_layer(_LOWER, _RAISE, _ADJUST);
    }
    else
    {
      layer_off(_LOWER);
      update_tri_layer(_LOWER, _RAISE, _ADJUST);
    }
    return false;
    break;
  case RAISE:
    if (record->event.pressed)
    {
      layer_on(_RAISE);
      update_tri_layer(_LOWER, _RAISE, _ADJUST);
    }
    else
    {
      layer_off(_RAISE);
      update_tri_layer(_LOWER, _RAISE, _ADJUST);
    }
    return false;
    break;
  case ADJUST:
    if (record->event.pressed)
    {
      layer_on(_ADJUST);
    }
    else
    {
      layer_off(_ADJUST);
    }
    return false;
    break;
  }
  return true;
}

