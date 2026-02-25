#include "LuaGameMode.h"

ALuaGameModeBase::ALuaGameModeBase(const FObjectInitializer& ObjectInitializer)
    : Super(ObjectInitializer)
{
}

FString ALuaGameModeBase::GetLuaFilePath_Implementation() const
{
    return LuaFilePath;
}

void ALuaGameModeBase::PostInitializeComponents()
{
    Super::PostInitializeComponents();

    ILuaOverriderInterface::PostLuaHook();
}

ALuaGameMode::ALuaGameMode(const FObjectInitializer& ObjectInitializer)
    : Super(ObjectInitializer)
{
}

FString ALuaGameMode::GetLuaFilePath_Implementation() const
{
    return LuaFilePath;
}

void ALuaGameMode::PostInitializeComponents()
{
    Super::PostInitializeComponents();
    
    ILuaOverriderInterface::PostLuaHook();
}
