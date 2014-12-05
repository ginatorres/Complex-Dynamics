#include "ee.h"





/***************************************************************************
 *
 * Kernel ( CPU 0 )
 *
 **************************************************************************/
    /* Definition of task's body */
    DeclareTask(TaskReferenceChange);
    DeclareTask(TaskController);
    DeclareTask(TaskActuator);
    DeclareTask(TaskSupervision);

    const EE_FADDR EE_hal_thread_body[EE_MAX_TASK] = {
        (EE_FADDR)FuncTaskReferenceChange,		/* thread TaskReferenceChange */
        (EE_FADDR)FuncTaskController,		/* thread TaskController */
        (EE_FADDR)FuncTaskActuator,		/* thread TaskActuator */
        (EE_FADDR)FuncTaskSupervision 		/* thread TaskSupervision */

    };

    /* ready priority */
    const EE_TYPEPRIO EE_th_ready_prio[EE_MAX_TASK] = {
        0x1U,		/* thread TaskReferenceChange */
        0x1U,		/* thread TaskController */
        0x1U,		/* thread TaskActuator */
        0x1U 		/* thread TaskSupervision */
    };

    /* dispatch priority */
    const EE_TYPEPRIO EE_th_dispatch_prio[EE_MAX_TASK] = {
        0x1U,		/* thread TaskReferenceChange */
        0x1U,		/* thread TaskController */
        0x1U,		/* thread TaskActuator */
        0x1U 		/* thread TaskSupervision */
    };

    /* thread status */
    #if defined(__MULTI__) || defined(__WITH_STATUS__)
        EE_TYPESTATUS EE_th_status[EE_MAX_TASK] = {
            EE_READY,
            EE_READY,
            EE_READY,
            EE_READY
        };
    #endif

    /* next thread */
    EE_TID EE_th_next[EE_MAX_TASK] = {
        EE_NIL,
        EE_NIL,
        EE_NIL,
        EE_NIL
    };

    EE_TYPEPRIO EE_th_nact[EE_MAX_TASK];
    /* The first stacked task */
    EE_TID EE_stkfirst = EE_NIL;

    /* The first task into the ready queue */
    EE_TID EE_rqfirst  = EE_NIL;

    /* system ceiling */
    EE_TYPEPRIO EE_sys_ceiling= 0x0000U;

    /* deadlines */
    const EE_TYPERELDLINE EE_th_reldline[EE_MAX_TASK] = {
        2000000,		/* thread TaskReferenceChange */
        2000000,		/* thread TaskController */
        2000000,		/* thread TaskActuator */
        4000000 		/* thread TaskSupervision */
    };
    EE_TYPEABSDLINE EE_th_absdline[EE_MAX_TASK];



/***************************************************************************
 *
 * Counters
 *
 **************************************************************************/
    EE_counter_RAM_type       EE_counter_RAM[EE_MAX_COUNTER] = {
        {0, -1}         /* myCounter */
    };



/***************************************************************************
 *
 * Alarms
 *
 **************************************************************************/
    const EE_alarm_ROM_type   EE_alarm_ROM[] = {
        {0, EE_ALARM_ACTION_TASK    , TaskReferenceChange, NULL},
        {0, EE_ALARM_ACTION_TASK    , TaskController, NULL},
        {0, EE_ALARM_ACTION_TASK    , TaskActuator, NULL},
        {0, EE_ALARM_ACTION_TASK    , TaskSupervision, NULL}
    };

    EE_alarm_RAM_type         EE_alarm_RAM[EE_MAX_ALARM];

