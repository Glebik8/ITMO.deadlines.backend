export interface User {
    id: number
    events: DeadlineEvent[];
}

export interface DeadlineEvent {
    id: number
    day: string[]
    time: string
    name: string
    description: string
}

export interface Id {
    id: number
}


