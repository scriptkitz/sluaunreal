#include "LuaAnimInstance.h"
#include "LuaState.h"
#include "Net/UnrealNetwork.h"

ULuaAnimInstance::ULuaAnimInstance(const FObjectInitializer& ObjectInitializer)
    : Super(ObjectInitializer)
{
}

FString ULuaAnimInstance::GetLuaFilePath_Implementation() const
{
    return LuaFilePath;
}

void ULuaAnimInstance::RegistLuaTick(float TickInterval)
{
    EnableLuaTick = true;
    auto state = NS_SLUA::LuaState::get();
    state->registLuaTick(this, TickInterval);
}

void ULuaAnimInstance::UnRegistLuaTick()
{
    auto state = NS_SLUA::LuaState::get();
    state->unRegistLuaTick(this);
}

void ULuaAnimInstance::GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const
{
    Super::GetLifetimeReplicatedProps(OutLifetimeProps);
    
    {
        DOREPLIFETIME_CONDITION(ULuaAnimInstance, LuaNetSerialization, COND_None);
    }
}
