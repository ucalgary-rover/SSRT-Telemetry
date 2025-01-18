/****************************************************************************
** Meta object code from reading C++ file 'roverangle.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.8.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../roverangle.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'roverangle.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.8.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN10RoverAngleE_t {};
} // unnamed namespace


#ifdef QT_MOC_HAS_STRINGDATA
static constexpr auto qt_meta_stringdata_ZN10RoverAngleE = QtMocHelpers::stringData(
    "RoverAngle",
    "xAngleChanged",
    "",
    "yAngleChanged",
    "xDangerChanged",
    "yDangerChanged",
    "set_x_danger",
    "in_danger",
    "set_y_danger",
    "x_angle",
    "y_angle",
    "danger_level_x",
    "danger_level_y",
    "x_danger",
    "y_danger"
);
#else  // !QT_MOC_HAS_STRINGDATA
#error "qtmochelpers.h not found or too old."
#endif // !QT_MOC_HAS_STRINGDATA

Q_CONSTINIT static const uint qt_meta_data_ZN10RoverAngleE[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       6,   60, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   50,    2, 0x06,    7 /* Public */,
       3,    0,   51,    2, 0x06,    8 /* Public */,
       4,    0,   52,    2, 0x06,    9 /* Public */,
       5,    0,   53,    2, 0x06,   10 /* Public */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
       6,    1,   54,    2, 0x02,   11 /* Public */,
       8,    1,   57,    2, 0x02,   13 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::Bool,    7,
    QMetaType::Void, QMetaType::Bool,    7,

 // properties: name, type, flags, notifyId, revision
       9, QMetaType::QReal, 0x00015003, uint(0), 0,
      10, QMetaType::QReal, 0x00015003, uint(1), 0,
      11, QMetaType::QReal, 0x00015c01, uint(-1), 0,
      12, QMetaType::QReal, 0x00015c01, uint(-1), 0,
      13, QMetaType::Bool, 0x00015003, uint(2), 0,
      14, QMetaType::Bool, 0x00015003, uint(3), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject RoverAngle::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_ZN10RoverAngleE.offsetsAndSizes,
    qt_meta_data_ZN10RoverAngleE,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_tag_ZN10RoverAngleE_t,
        // property 'x_angle'
        QtPrivate::TypeAndForceComplete<qreal, std::true_type>,
        // property 'y_angle'
        QtPrivate::TypeAndForceComplete<qreal, std::true_type>,
        // property 'danger_level_x'
        QtPrivate::TypeAndForceComplete<qreal, std::true_type>,
        // property 'danger_level_y'
        QtPrivate::TypeAndForceComplete<qreal, std::true_type>,
        // property 'x_danger'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // property 'y_danger'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<RoverAngle, std::true_type>,
        // method 'xAngleChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'yAngleChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'xDangerChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'yDangerChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'set_x_danger'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'set_y_danger'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>
    >,
    nullptr
} };

void RoverAngle::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<RoverAngle *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->xAngleChanged(); break;
        case 1: _t->yAngleChanged(); break;
        case 2: _t->xDangerChanged(); break;
        case 3: _t->yDangerChanged(); break;
        case 4: _t->set_x_danger((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 5: _t->set_y_danger((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _q_method_type = void (RoverAngle::*)();
            if (_q_method_type _q_method = &RoverAngle::xAngleChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _q_method_type = void (RoverAngle::*)();
            if (_q_method_type _q_method = &RoverAngle::yAngleChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
        {
            using _q_method_type = void (RoverAngle::*)();
            if (_q_method_type _q_method = &RoverAngle::xDangerChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 2;
                return;
            }
        }
        {
            using _q_method_type = void (RoverAngle::*)();
            if (_q_method_type _q_method = &RoverAngle::yDangerChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 3;
                return;
            }
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< qreal*>(_v) = _t->x_angle(); break;
        case 1: *reinterpret_cast< qreal*>(_v) = _t->y_angle(); break;
        case 2: *reinterpret_cast< qreal*>(_v) = _t->danger_level_x(); break;
        case 3: *reinterpret_cast< qreal*>(_v) = _t->danger_level_y(); break;
        case 4: *reinterpret_cast< bool*>(_v) = _t->x_danger(); break;
        case 5: *reinterpret_cast< bool*>(_v) = _t->y_danger(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setXAngle(*reinterpret_cast< qreal*>(_v)); break;
        case 1: _t->setYAngle(*reinterpret_cast< qreal*>(_v)); break;
        case 4: _t->set_x_danger(*reinterpret_cast< bool*>(_v)); break;
        case 5: _t->set_y_danger(*reinterpret_cast< bool*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *RoverAngle::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *RoverAngle::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ZN10RoverAngleE.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int RoverAngle::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 6;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void RoverAngle::xAngleChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void RoverAngle::yAngleChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void RoverAngle::xDangerChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void RoverAngle::yDangerChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
